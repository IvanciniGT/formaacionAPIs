#language:es
Característica: Recuperar datos de animales a través del api rest que he creado
  Escenario: Recuperar un animal que existe en la BBDD
    Dado        Que tengo el JSON con los datos de un animal:
        """
        {
            "nombre": "Pipo",
            "especie": "Perro",
            "raza": "Labrador",
            "edad": 3,
            "peso": 20
        }
        """
    # La acción que defino
       Y hago una petición de tipo "POST" a la url "/api/v1/animales" con el JSON anterior
       Y recibo un json de vuelta
       Y en el json aparece un campo "id"
    Cuando      hago una petición de tipo "GET" a la url "/api/v1/animales/" postponiendo el id del json anterior
    Entonces    recibo un código de respuesta http: 200
        Y       debo recibir un json de vuelta
        Y       ese json debe contener todos los datos del json que se envío
        Y       el json debe contener un campo "id" con el valor que se recibió
        Y       el json debe contener un campo "fecha_alta" con la fecha y hora actuales
# Pregunta... pero... yo creía que había dicho: Cualquier prueba se debe centrar en un UNICO ASPECTO del sistema.
# Y esta prueba no está trabajando contra: altaDeAinmalito y recuperarAnimalitoPorId... ein????!!?!
# Algo que objetar?
# NO... está prueba se centra en: 
#    Cuando      hago una petición de tipo "GET" a la url "/api/v1/animales/" postponiendo el id del json anterior
# Si el alta falla, ya tengo una prueba para eso.
#    Cuando hago una petición de tipo "POST" a la url "/api/v1/animales" con el JSON anterior

# Probar el escenario, se pide un animal que no existe
    Escenario: Recuperar un animal que no existe en la BBDD
        Dado        hago una petición de tipo "DELETE" a la url "/api/v1/animales/74"
        #Dado        que borro en la bbdd en la tabla "Animales" el registro con id 74
        Cuando      hago una petición de tipo "GET" a la url "/api/v1/animales/74"
        Entonces    recibo un código de respuesta http: 404
            Y       debo recibir un json de vuelta
            Y       ese json debe contener un campo "error" con el valor "No se ha encontrado el animal con el id 74"
