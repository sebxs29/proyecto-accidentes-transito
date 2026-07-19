// Seleccionar la base de datos
db = db.getSiblingDB("accidentes_transito_raw");


// ==========================================================
// 1. MOSTRAR LAS COLECCIONES
// ==========================================================

print("COLECCIONES DISPONIBLES:");
printjson(db.getCollectionNames());


// ==========================================================
// 2. CONTAR DOCUMENTOS
// ==========================================================

print("\nCANTIDAD DE DOCUMENTOS:");

print(
    "Siniestros:",
    db.siniestros_raw.countDocuments({})
);

print(
    "Vehículos:",
    db.vehiculos_raw.countDocuments({})
);

print(
    "Precipitación:",
    db.precipitacion_raw.countDocuments({})
);

print(
    "Temperatura:",
    db.temperatura_raw.countDocuments({})
);

print(
    "Fallecidos:",
    db.fallecidos_raw.countDocuments({})
);

print(
    "Población:",
    db.poblacion_raw.countDocuments({})
);


// ==========================================================
// 3. MOSTRAR DOCUMENTOS DE EJEMPLO
// ==========================================================

print("\nEJEMPLO DE SINIESTROS:");
db.siniestros_raw
    .find({})
    .limit(5)
    .forEach(documento => printjson(documento));

print("\nEJEMPLO DE VEHÍCULOS:");
db.vehiculos_raw
    .find({})
    .limit(5)
    .forEach(documento => printjson(documento));

print("\nEJEMPLO DE PRECIPITACIÓN:");
db.precipitacion_raw
    .find({})
    .limit(5)
    .forEach(documento => printjson(documento));

print("\nEJEMPLO DE TEMPERATURA:");
db.temperatura_raw
    .find({})
    .limit(5)
    .forEach(documento => printjson(documento));

print("\nEJEMPLO DE FALLECIDOS:");
db.fallecidos_raw
    .find({})
    .limit(5)
    .forEach(documento => printjson(documento));

print("\nEJEMPLO DE POBLACIÓN:");
db.poblacion_raw
    .find({})
    .limit(5)
    .forEach(documento => printjson(documento));