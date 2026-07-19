from pathlib import Path
import csv
import os

import pandas as pd
from dotenv import load_dotenv
from pymongo import MongoClient


# ==========================================================
# CONFIGURACIÓN DE RUTAS
# ==========================================================

RUTA_PROYECTO = Path(__file__).resolve().parents[1]
RUTA_RAW = RUTA_PROYECTO / "data" / "raw"
RUTA_ENV = RUTA_PROYECTO / ".env"

load_dotenv(RUTA_ENV)

MONGODB_URI = os.getenv(
    "MONGODB_URI",
    "mongodb://localhost:27017/"
)

MONGODB_DATABASE = os.getenv(
    "MONGODB_DATABASE",
    "accidentes_transito_raw"
)


# ==========================================================
# ARCHIVOS Y COLECCIONES
# ==========================================================

ARCHIVOS = {
    "siniestros_2019.csv": "siniestros_raw",
    "vehiculos_matriculados_2019.csv": "vehiculos_raw",
    "precipitacion_2019.csv": "precipitacion_raw",
    "temperatura_2019.csv": "temperatura_raw",
    "fallecidos_sppat.csv": "fallecidos_raw",
    "poblacion_censo_2022.xlsx": "poblacion_raw"
}


# ==========================================================
# DETECTAR CODIFICACIÓN Y SEPARADOR
# ==========================================================

def detectar_formato_csv(ruta_archivo):
    codificaciones = [
        "utf-8-sig",
        "utf-8",
        "cp1252",
        "latin-1"
    ]

    codificacion_correcta = None

    # Revisar el archivo completo, no solamente el inicio
    for codificacion in codificaciones:
        try:
            with open(
                ruta_archivo,
                "r",
                encoding=codificacion
            ) as archivo:

                while archivo.read(1024 * 1024):
                    pass

            codificacion_correcta = codificacion
            break

        except UnicodeDecodeError:
            continue

    if codificacion_correcta is None:
        raise ValueError(
            f"No se pudo detectar la codificación de "
            f"{ruta_archivo.name}"
        )

    # Detectar separador usando la codificación correcta
    with open(
        ruta_archivo,
        "r",
        encoding=codificacion_correcta,
        newline=""
    ) as archivo:
        muestra = archivo.read(20000)

    try:
        separador = csv.Sniffer().sniff(
            muestra,
            delimiters=",;\t|"
        ).delimiter

    except csv.Error:
        separador = ";"

    return codificacion_correcta, separador


# ==========================================================
# PREPARAR DOCUMENTOS PARA MONGODB
# ==========================================================

def preparar_documentos(dataframe, archivo_origen):
    dataframe = dataframe.copy()

    # Se agrega solamente como metadato de procedencia.
    dataframe["_archivo_origen"] = archivo_origen

    # MongoDB utiliza None como valor nulo.
    dataframe = dataframe.astype(object).where(
        pd.notna(dataframe),
        None
    )

    return dataframe.to_dict(orient="records")


# ==========================================================
# CARGAR CSV POR BLOQUES
# ==========================================================

def cargar_csv(ruta_archivo, coleccion, tamano_bloque=20000):
    codificacion, separador = detectar_formato_csv(ruta_archivo)

    print(
        f"  Codificación: {codificacion} | "
        f"Separador: {repr(separador)}"
    )

    total_insertado = 0

    lector = pd.read_csv(
        ruta_archivo,
        encoding=codificacion,
        sep=separador,
        chunksize=tamano_bloque,
        low_memory=False
    )

    for numero_bloque, dataframe in enumerate(lector, start=1):
        documentos = preparar_documentos(
            dataframe,
            ruta_archivo.name
        )

        if documentos:
            coleccion.insert_many(
                documentos,
                ordered=False
            )

            total_insertado += len(documentos)

        print(
            f"  Bloque {numero_bloque}: "
            f"{len(documentos):,} documentos"
        )

    return total_insertado


# ==========================================================
# CARGAR EXCEL
# ==========================================================

def cargar_excel(ruta_archivo, coleccion, tamano_bloque=20000):

    dataframe = pd.read_excel(
        ruta_archivo,
        sheet_name="3",
        header=16,
        usecols="B:G",
        engine="openpyxl"
    )

    dataframe = dataframe.dropna(how="all").reset_index(drop=True)

    dataframe.columns = [
        str(columna).strip()
        for columna in dataframe.columns
    ]

    dataframe["_hoja_origen"] = "3"

    total_insertado = 0

    for inicio in range(0, len(dataframe), tamano_bloque):

        fin = inicio + tamano_bloque
        bloque = dataframe.iloc[inicio:fin].copy()

        documentos = preparar_documentos(
            bloque,
            ruta_archivo.name
        )

        if documentos:
            coleccion.insert_many(
                documentos,
                ordered=False
            )

            total_insertado += len(documentos)

        print(
            f"  Filas cargadas: {inicio + 1:,} a "
            f"{min(fin, len(dataframe)):,}"
        )

    return total_insertado

# ==========================================================
# PROCESO PRINCIPAL
# ==========================================================

def main():
    if not RUTA_RAW.exists():
        raise FileNotFoundError(
            f"No existe la carpeta: {RUTA_RAW}"
        )

    cliente = MongoClient(
        MONGODB_URI,
        serverSelectionTimeoutMS=5000
    )

    try:
        # Comprueba que MongoDB está funcionando.
        cliente.admin.command("ping")

        print("Conexión correcta con MongoDB.")
        print(f"Base de datos: {MONGODB_DATABASE}")
        print(f"Carpeta raw: {RUTA_RAW}\n")

        base_datos = cliente[MONGODB_DATABASE]

        for nombre_archivo, nombre_coleccion in ARCHIVOS.items():
            ruta_archivo = RUTA_RAW / nombre_archivo

            print("=" * 60)
            print(f"Archivo: {nombre_archivo}")
            print(f"Colección: {nombre_coleccion}")

            if not ruta_archivo.exists():
                print(
                    f"NO ENCONTRADO: {ruta_archivo}\n"
                    "Revisa el nombre real del archivo.\n"
                )
                continue

            coleccion = base_datos[nombre_coleccion]

            # Elimina la carga anterior para no duplicar registros.
            coleccion.drop()

            extension = ruta_archivo.suffix.lower()

            if extension == ".csv":
                total = cargar_csv(
                    ruta_archivo,
                    coleccion
                )

            elif extension in {".xlsx", ".xls"}:
                total = cargar_excel(
                    ruta_archivo,
                    coleccion
                )

            else:
                print(
                    f"Formato no compatible: {extension}"
                )
                continue

            total_mongodb = coleccion.count_documents({})

            print(
                f"Carga terminada: {total:,} documentos"
            )
            print(
                f"Total comprobado en MongoDB: "
                f"{total_mongodb:,}\n"
            )

        print("=" * 60)
        print("Todas las cargas disponibles terminaron.")

        print("\nColecciones creadas:")

        for nombre in base_datos.list_collection_names():
            total = base_datos[nombre].count_documents({})

            print(f"- {nombre}: {total:,} documentos")

    except Exception as error:
        print("\nERROR DURANTE LA CARGA:")
        print(type(error).__name__)
        print(error)

    finally:
        cliente.close()


if __name__ == "__main__":
    main()