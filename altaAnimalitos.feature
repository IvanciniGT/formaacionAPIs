#language:es
Requisito: Dar de alta animales a través del api rest que he creado
# Quizás acabo con 30 pruebas... 30 cosas de uso... que me definen el api y su comportamiento
  Escenario: Dar de alta un animal que tiene todos sus datos correctos

    # Lo que necesito (estado, datos, recursos...) para que esto funcione
    # ESTO SERIA EL HAPPY PATH: el camino en el que todo funciona como se espera
    Dado Que tengo el JSON con los datos de un animal:
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
    Cuando hago una petición de tipo "POST" a la url "/api/v1/animales" con el JSON anterior
    # Lo que debe ocurrir
    Entonces recibo un código de respuesta http: 201
           Y debo recibir un json de vuelta
           Y ese json debe contener todos los datos del json que se envío
           Y el json debe contener un campo "id" con un valor numérico mayor que 0
           Y el json debe contener un campo "fecha_alta" con la fecha y hora actuales
           Y en la BBDD debo tener registrado en la tabla "Animales" el animal con los datos que se enviaron 
             bajo el id que se recibió en el json de vuelta
           Y en la bandeja de entrada del correo del usuario "El que sea" debe haber un email recibido en este momento
             con asunto: "Alta de animal: Pipo" 
           Y con el texto: "Perro" contenido en el cuerpo del email
           Y con el texto: "Labrador" contenido en el cuerpo del email
  # Casos límite
  # La misma prueba con peso 0
  Escenario: Dar de alta un animal que tiene todos sus datos correctos pero con peso 0
    Dado Que tengo el JSON con los datos de un animal:
        """
        {
            "nombre": "Pipo",
            "especie": "Perro",
            "raza": "Labrador",
            "edad": 3,
            "peso": 0
        }
        """
    Cuando hago una petición de tipo "POST" a la url "/api/v1/animales" con el JSON anterior
    Entonces recibo un código de respuesta http: 400
           Y debo recibir un json de vuelta
           Y ese json debe contener un campo "error"
           Y ese campo "error" debe contener el texto: "El peso no puede ser inferior a 1"
  # La misma pero con nombre vacío
  Escenario: Dar de alta un animal que tiene todos sus datos correctos pero con nombre vacío
        Dado Que tengo el JSON con los datos de un animal:
            """
            {
                "nombre": "",
                "especie": "Perro",
                "raza": "Labrador",
                "edad": 3,
                "peso": 20
            }
            """
        Cuando hago una petición de tipo "POST" a la url "/api/v1/animales" con el JSON anterior
        Entonces recibo un código de respuesta http: 400
             Y debo recibir un json de vuelta
             Y ese json debe contener un campo "error"
             Y ese campo "error" debe contener el texto: "El nombre no puede estar vacío"
  # La misma con nombre mayor que 50 caracteres
  Escenario: Dar de alta un animal que tiene todos sus datos correctos pero con nombre mayor que 50 caracteres
        Dado Que tengo el JSON con los datos de un animal:
            """
            {
                "nombre": "Enunlugar de laMancha de cuyo nombre no quiero acordarme",
                "especie": "Perro",
                "raza": "Labrador",
                "edad": 3,
                "peso": 20
            }
            """
        Cuando hago una petición de tipo "POST" a la url "/api/v1/animales" con el JSON anterior
        Entonces recibo un código de respuesta http: 400
             Y debo recibir un json de vuelta
             Y ese json debe contener un campo "error"
             Y ese campo "error" debe contener el texto: "El nombre no puede tener más de 50 caracteres"
  # Cuando tengo peso mayor que 200
  Escenario: Dar de alta un animal que tiene todos sus datos correctos pero con peso mayor que 200
        Dado Que tengo el JSON con los datos de un animal:
            """
            {
                "nombre": "Pipo",
                "especie": "Perro",
                "raza": "Labrador",
                "edad": 3,
                "peso": 201
            }
            """
        Cuando hago una petición de tipo "POST" a la url "/api/v1/animales" con el JSON anterior
        Entonces recibo un código de respuesta http: 400
             Y debo recibir un json de vuelta
             Y ese json debe contener un campo "error"
             Y ese campo "error" debe contener el texto: "El peso no puede ser superior a 200"
  # Y así con todos
  # Y eso son los casos límite
  # Luego vamos a por los casos de error
  # El campo nombre es obligatorio
  Escenario: Dar de alta un animal que no tiene el campo nombre
    Dado Que tengo el JSON con los datos de un animal:
        """
        {
            "especie": "Perro",
            "raza": "Labrador",
            "edad": 3,
            "peso": 20
        }
        """
    Cuando hago una petición de tipo "POST" a la url "/api/v1/animales" con el JSON anterior
    Entonces recibo un código de respuesta http: 400
           Y debo recibir un json de vuelta
           Y ese json debe contener un campo "error"
           Y ese campo "error" debe contener el texto: "El campo nombre es obligatorio"