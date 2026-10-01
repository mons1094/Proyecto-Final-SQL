# Proyecto Capstone: Análisis Exploratorio de Datos (EDA) en PostgreSQL - Taxis NYC

## 📌 Contexto del Proyecto y Problema de Negocio
Este proyecto simula el flujo de trabajo de un analista de datos aplicado a un conjunto de registros de viajes de taxis de la ciudad de Nueva York. 

El objetivo principal es responder preguntas estratégicas de negocio para optimizar la toma de decisiones operativas de la flota:
1. **Rendimiento por método de pago:** Evaluar qué métodos generan más ingresos y mejores márgenes de propina para los conductores.
2. **Demanda por distrito (Borough):** Identificar las zonas con mayor densidad de viajes para optimizar la distribución geográfica de las unidades.
3. **Métricas por tipo de servicio (Color de unidad):** Determinar las diferencias de uso, duración y tarifas entre los taxis amarillos y verdes.

---

## 📊 Hallazgos Principales (Conclusiones)

- **Métodos de pago e Ingresos:**
  - Los pagos con **Tarjeta de Crédito** representan la mayor parte de la facturación y son la única modalidad donde se registran propinas de forma constante a través del sistema.
  - El pago en **Efectivo** no registra propinas digitales dentro del dataset, lo cual sugiere un posible sesgo en el registro o propinas entregadas en mano directamente al chofer.

- **Demanda Geográfica:**
  - El distrito de **Manhattan** concentra el volumen predominante de la demanda de viajes, aunque presenta distancias promedio más cortas debido a la alta densidad urbana.
  - Distritos periféricos como **Queens** registran recorridos considerablemente más largos (trayectos a aeropuertos), generando tarifas promedio por viaje más altas.

- **Comparativa por Tipo/Color de Vehículo:**
  - Los **taxis amarillos (*Yellow cabs*)** presentan una mayor frecuencia en viajes de corta/mediana distancia en zonas céntricas.
  - Los **taxis verdes (*Green cabs*)** tienden a operar en zonas periféricas con trayectos ligeramente más extensos y tarifas base diferenciadas.

---

## 🛠️ Estructura del Repositorio

El repositorio está organizado en los siguientes archivos requeridos:

- **`estructura.sql`**: Contiene la definición de la base de datos `capstone_project`, la estructura DDL de la tabla `taxis` con los tipos de datos adecuados (`TIMESTAMP`, `NUMERIC`, `INTEGER`, etc.) y las instrucciones de creación.
- **`analisis.sql`**: Agrupa la etapa de limpieza de datos mediante una vista (`v_taxis_limpios`) utilizando `COALESCE` para el manejo de valores nulos, junto con las tres consultas SQL de negocio debidamente comentadas.
- **`README.md`**: Explicación del problema, hallazgos clave e instrucciones de ejecución.

---

## 🚀 Pasos para Ejecutar el Código

### 1. Requisitos Previos
- Tener instalado **PostgreSQL** y **pgAdmin 4** (o la consola `psql`).
- Contar con el archivo CSV de datos de taxis.

### 2. Configuración de la Base de Datos y Estructura
1. Abre **pgAdmin** y crea una base de datos llamada `capstone_project`.
2. Abre la herramienta de consultas (**Query Tool**) sobre esa base de datos.
3. Abre el archivo **`estructura.sql`** e ejecútalo para crear la tabla `taxis`.

### 3. Importación de Datos
Importa tu archivo CSV a la tabla `taxis` ejecutando este comando en el Query Tool (asegúrate de ajustar la ruta de tu archivo CSV):

```sql
\copy taxis FROM 'C:/ruta/a/tu/archivo.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
