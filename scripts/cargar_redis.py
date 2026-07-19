import redis
import pandas as pd
import os

# CONEXIÓN A REDIS

r = redis.Redis(
    host="localhost",
    port=6379,
    decode_responses=True
)

try:
    r.ping()
    print("✅ Conectado a Redis correctamente")
except:
    print("❌ No se pudo conectar a Redis")
    exit()

# RUTA DE LOS CSV

RUTA = r"D:\c++\proyeto\proyecto-accidentes-transito\data\final"

# ARCHIVOS A CARGAR

archivos = {
    "fact_siniestros": "fact_siniestros.csv",
    "fechas": "dim_fecha.csv",
    "ubicacion": "dim_ubicacion.csv",
    "poblacion": "dim_poblacion.csv",
    "clima": "dim_clima.csv",
    "vehiculos": "dim_vehiculo.csv"
}

# LIMPIAR REDIS (OPCIONAL)


r.flushdb()

print("Base Redis vaciada.\n")

# INSERTAR DATOS


for nombre_tabla, archivo in archivos.items():

    ruta_csv = os.path.join(RUTA, archivo)

    df = pd.read_csv(ruta_csv)

    print(f"Cargando {archivo}...")

    for i, fila in df.iterrows():

        # Buscar columna ID
        id_col = None

        for c in df.columns:
            if c.lower().startswith("id_"):
                id_col = c
                break

        if id_col:
            clave = f"{nombre_tabla}:{fila[id_col]}"
        else:
            clave = f"{nombre_tabla}:{i+1}"

        datos = {}

        for columna in df.columns:

            valor = fila[columna]

            if pd.isna(valor):
                datos[columna] = ""
            else:
                datos[columna] = str(valor)

        r.hset(clave, mapping=datos)

    print(f"   {len(df)} registros cargados.\n")

print("Carga finalizada correctamente.")
