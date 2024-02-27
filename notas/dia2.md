
# Desarrollo de APIs WEB

## Uso del protocolo HTTP

Reglas para la transferencia de datos entre un cliente y un servidor.
Es un protocolo de comunicación unidireccional, es decir, el cliente hace una petición y el servidor responde.
El servidor no puede iniciar la comunicación con el cliente.
Hay otros protocoles que usamos en el mundo web que si permiten comunicación bidireccional, como WebSockets.

En una petición http siempre tenemos 2 partes:
- Cabecera: Información sobre la petición, como el método, la url, el tipo de contenido, etc.
            Dentro de la cabecera, lo que mandamos son los headers.
- Cuerpo: Información adicional que se envía en la petición, como los datos de un formulario.

Es como si amazon me envía un paquete a mi casa... he comprado un libro.
El libro no me lo mandan a pelo... viene en una caja. (el libro es el cuerpo de la petición) 
La cabecera, y su headers, son la pegatina que pone amazon a la caja... que lleva algunos metadatos:
- Quien lo envía
- Quien lo recibe
- Peso
- Si es frágil

Esto ocurre tanto en peticiones como en respuestas.

    CLIENTE ---> Emite una petición (request)    ---> SERVIDOR
    CLIENTE <--- Recibe una respuesta (response) <--- SERVIDOR

Tanto en request como en response, vamos a tener esa caja, con un cuerpo (contenido) y una pegatina (cabecera).
Puede ocurrir que la caja vaya vacía, pero siempre va a haber una caja.

## Headers comunes en una petición HTTP

- **Host**: El nombre del host al que se está haciendo la petición.
- **User-Agent**: Información sobre el navegador o cliente que está haciendo la petición.
                  User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36
- **Content-Type**: El tipo de contenido que se está enviando en el cuerpo de la petición.
                    application/json
                    application/x-www-form-urlencoded
                    application/xml
- **Content-Length**: La longitud del cuerpo de la petición (bytes)
- **Cache-Control**: Controla la caché del navegador. Indica si el navegador puede almacenar en caché la respuesta.
- **Authorization**: Información de autenticación. Se usa para enviar credenciales al servidor.
                     Authorization: Bearer TOKEN
- **Aceptar**: Indica al servidor qué tipo de contenido puede aceptar el cliente.
               Aceptar: application/json
                        application/xml
Hay un dato que también se manda como header, pero se trata aparte, que es el método de la petición.
Hay otro metadato que se manda en el header también... pero en las respuestas, que es el código de estado.

## Métodos de petición HTTP

| METODO  | DESCRIPCION | 
| ------- | ----------- |
| GET     | Recuperar datos del servidor |
| POST    | Crear datos en el servidor |
| PUT     | Actualizar datos en el servidor (a veces crea también... pero diferente al POST) |
| DELETE  | Borrar datos en el servidor |
| PATCH   | Actualizar parcialmente datos en el servidor |
| HEAD    | Similar a GET, pero solo recupera la cabecera de la respuesta |
| OPTIONS | Devuelve los métodos HTTP que el servidor soporta |

## Código de estado HTTP

- 2XX: Éxito
  - 200: OK                                                     GET, POST, PUT, DELETE, PATCH
  - 204: OK, pero no te mando nada de vuelta                    PUT, DELETE, PATCH, HEAD
  - 201: Creado                                                 POST, PUT
  - 202: Aceptado: He recibo existosamente tu petición... pero aún no he hecho nada con ella... se hará!
            Cuando tengo métodos asíncronos... que no se ejecutan en el momento... sino que se encolan y se ejecutan después.                                   POST, PUT
- 3XX: Redirección                                              Cualquier método
- 4XX: Error del cliente
  - 400: Solicitud incorrecta BAD REQUEST                       Cualquier método. Solamente
                                                                debería usarse pata problemas de sintaxis o similar.
  - 401: No autorizado                                          Cualquier método
            No se quien eres
  - 403: Prohibido                                              Cualquier método
            Se quien eres... pero no tienes permiso
  - 404: No encontrado                                          Cualquier método
  - 409: Conflicto                                              PUT POST DELETE
            El recurso ya existe y la petición que me pide no puedo procesarla debido al estado (sus propiedades) actual del recurso.
                Me estás pidiendo que lleve el expediente de "estado" cancelado a aprobado... y eso no puede ser.
- 5XX: Error del servidor

## Consideraciones al diseñar un API web REST

- **Uso adecuado de verbos**
- **Nombres de recursos en plural**: Siempre en plural. 
  - /api/v1/animales
  - /api/v1/usuarios
  - /api/v1/empleados
- **Incluir la versión de la API (MAJOR) en la URL**: /api/v1/animales
- **Códigos de estado adecuados**
- **Uso de subrecursos**: /api/v1/animales/pipo/multimedia
                          /api/v1/clientes/B10292837/facturas
                          /api/v1/facturas
- ** Consistencia en la nomenclatura de los endpoints**: 
  - camelCase
  - snake_case
  - kebab-case
- **Idempotencia**: Un método es idempotente si al ser llamado deja el servidor siempre en un mismo estado final, con independencia del estado inicial en el que se encuentre el servidor.

    Es importante tenrlo en cuenta ya que en ocasiones al hacer una petición, el servidor puede no responder, o la conexión puede caerse, y si el método no es idempotente, y el cliente trata de reenviar la petición, el servidor puede quedar en un estado no deseado.

  - GET: Siempre va a devolver lo mismo.
            http://animalitosfermin.com/api/v1/animales/pipo
                Da igual si el animal existe o no... después de la petición seguirá existiendo o no... y con los mismo datos caso de existir.
  - DELETE: Siempre va a borrar el mismo recurso.
              http://animalitosfermin.com/api/v1/animales/pipo  Si existe se borra... Si no existe ... pues sigue igual... sin existir
              A partir de ahí, da igual si llamo al método 200 veces... el estado no va a cambiar
  - HEAD: Siempre va a devolver la misma cabecera.
  - OPTIONS: Siempre va a devolver los mismos métodos.
  
  - PUT: Es idempotente. PUT puede modificar o crear recursos.
            http://animalitosfermin.com/api/v1/animales/pipo
                { "nombre": "Pipo", "tipo": "gato" }
                
                Si pipo no existe se crea... Si existe, sus propiedades son actualizadas.
                Siempre va a actualizar el mismo animalito... y si lo vuelvo a llamar, va a actualizar el mismo animalito.

  - PATCH: Debe ser idempotente.... pero a veces me cuesta conseguirlo... o al menos tengo que tener cuidado.
           Se usa para modificar recursos... pero distinto al put.
              PUT: Modifica el recurso completo (todos sus datos)
              PATCH: Modifica solo una parte del recurso.
                Al modificar esa parte que quiero modificar con PATCH, el recurso final debe quedar siempre en el mismo estado.

                    Expedientes... que tienen un estado... y quiero cambiar el estado de un expediente.
                        Estado inicial: Alta -> Estado final: Aprobado
                    Asociado al cambio de estado pueden ocurrir otras cosas... cambiar la fecha de aprobación.
                    Si al implementarlo no tengo en cuenta que el cambio de estado a aprobado solo se puede realizar desde el estado alta... puedo tener problemas.
                        La segunda vez que llame al método, el estado ya no será alta... seguiré dejando el estado aprobado... pero me cambiará la fecha de aprobación. = NO IDEMPOTENTE !

  - POST: No es idempotente. Siempre va a crear un recurso nuevo.
            http://animalitosfermin.com/api/v1/animales
                { "nombre": "Pipo", "tipo": "perro" }
                Siempre va a crear un nuevo animalito... y si lo vuelvo a llamar, va a crear otro nuevo animalito. 

                Aun definiendo el "nombre" como clave unica
                { "nombre": "Pipo", "tipo": "gato" }

---

# Seguridad en APIs WEB

## Identificación

Que el cliente se identifique... diga quién es.

## Autenticación

Que el servidor se asegure de que yo soy quien digo ser.

## Autorización

Sabiendo que eres quien dices ser, que puedes hacer y que no.

---

# Desarrollo de un API REST

Con todas esas consideraciones, nos pondremos manos a la obra a diseñar nuestro API REST.
    
    Endpoints
        Métodos
            Argumentos URL
            Autorización
            Cuerpo admitido
            Respuesta
                Códigos de estado
                    Cuerpo de la respuesta

Una vez planteado eso... nos ponemos a probar el api ??  EIN??? TDD/BDD/ATDD
Quiero probar la implementación? Ahora no... no tengo implementación... tengo un diseño.
Me sirve ese API? Responde a mis necesidades? Es lo que quiero? Es lo que necesito?

No me voy a meter a implementar un API sin saber si es el API que necesito.

Pruebas:
    - Revisión del diseño para ver si cumple con los requisitos
    - Es cómodo de usar? 
    - CASOS DE USO > ME ayudan a entender el comportamiento que debe tener la implementación del API
      Y cuando lo conozca, me pongo a picar código
    OPCIONALMENTE me plantearé diseñar las pruebas automatizadas de sistema del API. HOY, no cuando tenga el código.
    Y entonces y solo entonces... me pongo a picar código.
    Y sabré que he terminado cuando todas las pruebas automatizadas de sistema pasen.

Para automatizar esas pruebas usaré:
- Postman
- SoapUI
- ReadyAPI
  - No sirve solo para pruebas
  - También ayuda a especificar el API/diseñar el API -> Swagger
- Karate

# Swagger

Un formato de documentación de APIS REST. El que se usa de facto en el mundo de las APIS REST.

Los que trabajais con JAVA/SpringBoot... sabeis que se puede generar la documentación de un API REST automáticamente a partir de las anotaciones que se ponen en el código.

En .NET también se puede hacer.

Swagger por cierto que le llamábamos así a las versiones antiguas... v1 y v2.
La versión 3 de swagger se llama OpenAPI.

Detrás de Swagger está SmartBear... que es la empresa que desarrolla SoapUI y ReadyAPI.
---

# Pruebas de software

## Vocabulario en el mundo del testing:

- Error:    Los humanos cometemos errores (por estar cansados, distraidos, faltos de conocimiento, mala comunicación, etc)
- Defecto   Al cometer un error podemos introducir un defecto en el software.
- Fallo     Ese defecto puede manifestarse como un fallo en el software al usarlo.

## Para qué sirven las pruebas?

- Validar los requisitos
- Verificar el cumplimiento de unos requisitos
- Comprobar retrocompatibilidad (regresión)
- Identificar problemas/caso de uso en etapas tempranas de desarrollo
  Validar diseños
- Identificar mejoras / Extraer conocimiento que pueda aplicarse a otros proyectos
- Identificar antes del paso a producción la mayor cantidad posibles de fallos
  Una vez identificado un fallo, será necesario identificar el defecto que lo provoca, para subsanarlo.
  El proceso de identificar un defecto desde un fallo se llama: depuración (debugging)
- Aportar toda la información posible para que el equipo de desarrollo pueda realizar un rápido debugging.
- Identificar antes del paso a producción la mayor cantidad posibles de defectos
      MESA (carpintero del ikea)
      Tengo un listón y voy a cortar las patas... y me equivoco al medir... me despisto... y hago una pata más corta.
      Tengo una mesa defectuosa (coin una pata más corta)
      Si lleno la mesa de platos (ejecutar la mesa) y siento a la gente a cenar... la mesa se pega una ostia... y todos los platos al suelo = fallo
      Podría solo revisar la mesa... me alejo un poco y la miro... COÑO TIENE UNA PATA MÁS CORTA... defecto

- Puedo hacer un análisis de causas raíces... para identificar los ERRORES y tomar acciones preventivas que eviten nuevos ERRORES > DEFECTOS > FALLOS en el futuro
- Para saber que tal va mi proyecto

    > El software funcionando es la MEDIDA principal de progreso.
      la MEDIDA principal de progreso es "El software funcionando"
      El cómo sé si mi proyecto va bien o mal... lo que voy a usar para medir el progreso de mi proyecto es 
      el concepto: "software funcionando"
      Esta frase define un INDICADOR de progreso.

      ¿Qué es software funcionando? Software que funciona... que cumple con los requisitos... que no provoca fallos... que no tiene defectos....

      ¿Quién me dice que el software funciona? LAS PRUEBAS !
    
    > DEVOPS: Es la cultura de la automatización. Quiero automatizar todo lo que hay entre el dev -> ops

        PLAN > CODE > BUILD > TEST > RELEASE > DEPLOY > OPERATE > MONITOR
               >>>>>>>>>>>>> Desarrollo ágil               PRODUCTO: ARTEFACTO
               >>>>>>>>>>>>>>>>>>>>> Integración continua! PRODUCTO: Informe de pruebas! QUE VALE ORO
               >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Entrega continua
               >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Despliegue continuo

## Tipos de pruebas

Se clasifican en base a diferentes taxonomías (criterios) paralelos entre si:
Cualquier prueba se debe centrar en un UNICO ASPECTO del sistema. Para qué? para que si falla sepa qué está fallando... y pueda hacer un rápido debugging.

### En base al objeto de prueba

- Pruebas funcionales
- Pruebas no funcionales
  - Pruebas de rendimiento
  - Pruebas de seguridad
  - Pruebas de usabilidad
  - carga
  - estrés

### En base al nivel de la prueba

- Unitarias             Se centra en una característica de un componente AISLADO del sistema.
- Integración           Se centra en la COMUNICACION entre 2 componentes
- Sistema (End-to-End)  Se centra en el COMPORTAMIENTO del sistema en su conjunto
  - Aceptación

### En base al procedimiento de ejecución:

- Dinámicas: Las que requieren ejecutar código:     Identifican FALLOS
- Estáticas: Las que no requieren ejecutar código:  Identifican DEFECTOS
    Revisión de requisitos
    Revisión de diseño
    Revisión de calidad de código: SonarQube

### En base al conocimiento del objeto de prueba

Pruebas de caja blanca: Conocemos el código fuente
Pruebas de caja negra: No conocemos el código fuente

## Metodologías de pruebas

### Test-First

Desarrollo primero las pruebas y luego el código.

### TDD: Test Driven Development

Test-First + Refactorización en cada iteración

### BDD: Behavior Driven Development

TDD + Lenguaje natural explicando casos de uso y comportamiento del sistema.

### ATDD: Acceptance Test Driven Development

Pruebas de aceptación. Pruebas que se hacen para validar que el sistema cumple con los requisitos del cliente.

---

# URL: Uniform Resource Locator

  protocolo://dominio:puerto/ruta?queryStrings
  En el queryStrings se pueden enviar parámetros adicionales:
    ?nombre=pepe&edad=23&ciudad=madrid
  En esos parámetros hay que tener cuidado con la codificación de caracteres especiales.
    Si quiero enviar un espacio, por ejemplo, debo enviarlo como %20
    ?nombre=pepe%20perez&edad=23&ciudad=madrid
  Hay que hacer un URL_ENCODE de los parámetros.

---

## Implementación de un API REST

                                Datos                               Código
    CAPA DE DOMINIO             Entidades                           Repositorio     Lógica de persistencia
    CAPA DE NEGOCIO             DTO                                 Servicio        Lógica de negocio
    CAPA DE CONTROLADOR         DTO2                                Controlador     Lógica de exposición

    AnimalitosRepositorio   <   AnimalitosServicio      <    AnimalitosRestControlerV1
        Animalitos                DatosAnimalitos               DatosNuevoAnimalitoRestV1
                                  DatosNuevoAnimalito           DatosAnimalitoRestV1

                                                        <    AnimalitosRestControlerV2
                                                                DatosNuevoAnimalitoRestV2
                                                                DatosAnimalitoRestV2
        
      Animalito .save(Animalito)    
                                    DatosAnimalito .nuevoAnimalito(DatosNuevoAnimalito)
                                        crea un objeto de tipo Animalito desde el DatosNuevoAnimalito
                                            Esa operación la delegaremos a qué? Mapeador
                                        persiste el Animalito
                                        envía un email... que estará delegado al EmailService
                                                                                    .enviarEmail(asunto, cuerpo, destinatario)

AnimalitosService >>>> EVENTO NUEVO ANIMALITO (COLA KAFKA) <<<< EMAILS SERVICE
                                                           <<<< VETERINARIOS CITA SERVICE
                                                           <<<< SMS SERVICE

Puedo hacer una prueba UNITARIA AL AnimalitosServicio? SI.. aislado?

    AnimalitosServicio
         .nuevoAnimalito
            DEPENDENCIAS: 
                AnimalitosRepositorio               AnimalitosRepositoryFake / AnimalitosRepositoryStub
                    Que la BBDD está caída
                EmailService                        EmailServiceSpy / EmailServiceMock
                    Servidor de email no está activo
                AnimalitosMapeador                  AnimalitosMapeadorFake / AnimalitosMapeadorStub
    
Y pruebas de integración puedo? CLARO QUE PUEDO... y debo... 3 pruebas diferentes:
- Integración del AnimalitosServicio con el AnimalitosRepositorio
    - Para hacerla mantengo:
        EmailsServiceSpy
        AnimalitosMapeadorFake 
- Integración del AnimalitosServicio con el EmailService
    - Para hacerla mantengo:
            AnimalitosRepositoryFake
            AnimalitosMapeadorFake
- Integración del AnimalitosServicio con el AnimalitosMapeador
    - Para hacerla mantengo:
            AnimalitosRepositoryFake
            EmailServiceSpy

Y la prueba de sistema... sin usar fakes ni stubs... sino con la implementación real de las dependencias.

A un API, por definición, lo que puedo hacerle son pruebas de sistema.
Es como me comunico con ese sistema/aplicación.
No tengo control de lo que hay dentro.
    Solo tengo entrada y salida.

## Test doubles

Objetos de pruebas que nos ayudan a aislar componentes y más:
- Dummy
- Fake
- Stub
- Spy
- Mock

---

# Definir casos de uso para el API

Tenemos un lenguaje que nos ayuda mucho con ello... que es Gherkin.

Cucumber es una herramienta/librería de pruebas, que nos permite ejecutar ficheros definidos en lenguaje GHERKIN usando código en cualquier lenguaje de programación.

Gherkin es un lenguaje de definición de casos de uso:
- Definir los requisitos
- Se convierten semi-automáticamente en pruebas de sistema (ESTO ES LO QUE HACE CUCUMBER)

Lo bueno de gherkin es que es un lenguaje en el que hablamos en lenguaje natural... de los que hablamos los seres humanos.
Lo tenemos disponible en Inglés, Español, Asturiano, Aragonés, catalán.

---

En el mundo del testing también tenemos un acrónimo guay para los principios del testing: FIRST
- F: Fast (me pueden ayudar los dummy)
- I: Independent. No debe depender del contexto, del estado inicial, ni de otras pruebas
- R: Repeatable. Siempre que se ejecute la prueba, debe dar el mismo resultado.
- S: Self-Validating. La prueba debe comprobar todo lo que debe ocurrir para que se considere que ha pasado.
- T: Timely. Debe hacerse en el momento adecuado. No antes, no después.

---

# Comunicaciones entre servicios

## Síncronas

El emisor (cliente) espera la respuesta del receptor (servidor) antes de continuar con su ejecución.

## Asíncronas

El emisor (cliente) no espera la respuesta del receptor (servidor) antes de continuar con su ejecución.

Tengo un computador (TPV) en el mercadona... y cuando me pasan la compra, paso la tarjeta por el tpv.
El tpv tiene dentro un programa que comunica con el banco de turno... oye! haz cargo de 300 billetes!
El TPV espera respuesta? SI
Si no se recibe respuesta, o la respuesta es negativa, no me dejan salir de la tienda.
ESA COMUNICACION DEBE SER SINCRONA

Tengo un computador (TPV) en la entrada de un peaje... y cuando salgo del peaje, paso la tarjeta por el tpv.
El tpv tiene dentro un programa que comunica con una cola de mensajería... oye! marca que hay que hacer un cargo de 8 billetes!
El TPV espera respuesta del banco? NO
Y YO ME VOY
Comunicación Asíncrona

Qué podría pasar si la comunicación fuese síncrona?
- Se acumularían coches... es eso un problema? NO tampoco lo es en el mercadona... más filas de caja
- Qué pasa si he ha caído el banco? No puedo salir del peaje... y estoy sufriendo un infarto?
ESO SI ES UN PROBLEMA !

Además de requisitos funcionales...
puede haber otro tipo de requisitos ue me inviten a tomar decisiones en este sentido:

- Requisitos de rendimiento
  Doy de alta el animal... y se debe mandar un email... Voy a esperar confirmación del servidor de emails?
    Ni de coña... :
        1. iría muy lento
        2. Si el servidor está caído... no se da de alta el animal?
    Simplemente anoto en un sistema que hay que mandar el email... ya alguien lo mandará cuando pueda

- Qué me asegura la comunicación ASINCRONA Que no me asegura la SINCRONA? Entrega del mensaje
    Si yo llamo por teléfono a mi madre para contarle algo... corro el riesgo de que mi madre no esté disponible... y en ese caso la comunicación no se ha podido efectuar...
    Si acaso, deberé guardarme el mensaje en memoria... y reintentarlo más tarde.

    En cambio si le mando un whatsapp... realmente no le mando el mensaje a mi madre... a quién se lo mando?
    Al servidor de whatsapp... que recoge el mensaje y me confirma la recepción.
    Cuando mi madre esté disponible, el servidor de whatsapp le entregará el mensaje.
    Pero yo me olvido. Se que eso ocurrirá! Y no tengo que preocuparme de ello.

    Operaciones críticas necesitan garantías de entrega... y eso lo da la comunicación asíncrona.

    Tenemos servidores de mensajería: 
    - RabbitMQ
    - Kafka
    Y los hay de 2 tipos:
    - push: RabbitMQ: RabbitMQ manda el mensaje al receptor
    - pull: Kafka:    El receptor va a buscar el mensaje al Kafka

- En ocasiones usamos servidores de mensajería para DESACOPLAR servicios entre si.

    Siguiendo el Principio SOLID DE RESPONSABILIDAD ÚNICA, mi misión es dar de alta un animal.
    No se qué pasa después.
    Ni me importa.
    Lo único que hago es notificar un evento... NUEVO ANIMALITO-> COLA KAFKA
    Habrá programas que les interese escuchar ese evento... y reaccionar en consecuencia.
    1 o 7000... no me importa.
    Cada vez que un programa necesite hacer algo cuando se da de alta un animal... simplemente se suscribirá a la cola del sistema de mensajería. Y preguntará (o le avisarán) cuando un animal se da de alta.... para hacer lo que tenga que hacer.
Esto me permite crear software más desacoplado... más fácil de mantener... más fácil de escalar.
Ahora hay que mandar también un SMS...
No hay que tocar NADA del código que existe. ESTO ES BRUTAL !!!
Hago un programa NUEVO, de CERO... que lea de la cola y envíe SMS... y listo.

Si tengo que tocar el programa que da alta animales, para meter entre 2 lineas de código la llamada a la función de envío de SMS... que impacto tiene esto?
- Nueva versión
- Nuevas pruebas
- Nuevo despliegue en producción
- Riesgo de que haya cosas que dejen de funcionar
- A lo mejor estamos en medio de una reestructuración del código de esa función... por tanto, dónde hago el cambio? 
 -  En lo nuevo? Pues tendré que esperar a qué esté acabado para poder subir a producción
 -  En lo viejo? Así subo ya... pero lo debo de copiar también al nuevo...
FOLLON !!!!!


# Validación de datos

<----- FrontEnd -------------------->    <---------- Backend ---------------------------->
Componente WEB           > Servicio   >  Controlador REST > Servicio > Repositorio  > BBDD
Formulario Nuevo Cliente                                       *                      *
 *                                       Controlador SOAP >                           Validación del tipo
 Validación de costesía                                       Validación de negocio

                                         En v1 del servicio, el tipo de animal: 1, 2, 3, 4
                                         En v2 del servicio, el tipo de animal: perro, gato, loro, papagaio
                                            ^^ ESTA VALIDACION A NIVEL DEL CONTROLADOR

    Fecha de nacimiento de un animal
    YO, en mi negocio! No puedo tener animales nacidos en el futuro.

    Si tuviera un único sitio dónde validar el email cual sería?
    La BBDD también tiene su responsabilidad... y su lógica.
    Y si alguien le da por pasar como el culo de tu puñetero programa... y quiera hacer una query directa a la bbdd está leyendo un dato inválido
    La BBDD es el último garante del dato.