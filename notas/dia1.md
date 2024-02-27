# Metodologías de desarrollo y pruebas de APIs web

## API: application programming interface

Cuando creamos una aplicación, otras aplicaciones pueden necesitar comunicarse con la nuestra, y para ello usarán nuestro API.

API: colección de métodos y funciones + argumentos que requieren + forma de invocarlos, que se pueden usar para interactuar con un sistema/aplicación.

- JAVA/.net: interfaces + objetos de transporte de datos.

    App1 JAVA     ->      App2 JAVA
    Si las 2 apps se ejecutan en la misma MAQUINA VIRTUAL DE JAVA

    En el mundo JAVA tenemos el concepto de Servidor de Aplicaciones: Un servidor web vitaminizado.

    Necesito comunicar el servidor de aplicaciones JAVA -> API(J2EE) -> Una app web desarrollada en JAVA

    Estas apps se comunican directamente llamando a objetos en RAM y sus funciones. Las clases/Interfaces que definen esos objetos y las funciones que se pueden invocar se llaman API.

- Cuando quiero comunicar 2 programas en distintas empresas... necesito un API... que puede usar las reglas del protocolo HTTP y el lenguaje JSON o XML

- Cuando quiero desarrollar una aplicación en mi empresa... puedo usar también este concepto... y nos salen las arquitecturas orientadas a servicios/microservicios.
  Este tema surge para resolver los problemas que estábamos teniendo al desarrollar apps con la arquitectura que estaba de moda en ese momento (2000-20010) : ARQUITECTURAS MONOLITICAS

## WEB

Internet es un conjunto descentralizado de redes de comunicaciones, que sirven para comunicar programas que corren en distintas máquinas.

Sobre internet se ofrecen muchos servicios:
- Correo electrónico (SMTP, POP3, IMAP)
- Juegos online
- TV
- Web. Fundada por Tim Berners-Lee en 1989 es el conjunto: 
  - de protocolos HTTP
  - de lenguajes HTML (HTML por favor... no es un lenguaje de programación, es un lenguaje de marcado)

### Motivación de la WEB

Antiguamente no teníamos redes... y desarrollabamos aplicaciones que se ejecutaban en una sola máquina.
En un momento dado surgen las redes... y nos planteamos dividir el código de nuestras aplicaciones en varias máquinas.

    App de escritorio (VBasic) --> BBDD Que tenía en un servidor  <-- App de escritorio (VBasic)
                                        ^^^^   vvvvv
    App de escritorio (VBasic) --> Programas que se ejecutan en un servidor

Es el comienzo de las arquitecturas Cliente-Servidor

Poco a poco eso fue evolucionando.... y empezamos a cargar más código en el lado del servidor:
- Hay que generar un informe con los datos de la BBDD
- Hay que hacer un programa que importe datos de un fichero.

Para comunicar 2 programas, necesitamos:
- Emisor
- Receptor
- Lenguaje
- Canal
- Mensaje
- Protocolo

                                   (lenguaje)
      YO (emisor)             ----> MENSAJE --->              MI PRIMO (receptor)
       Walkie Talkie          -> Canal (AIRE) ->              Walkie Talkie

      Para que la comunicación sea efectiva, hace falta un protocolo: El conjunto de reglas que se van a seguir para que la comunicación sea efectiva. En el caso de un walkie talkie, que reglas seguimos:
      - Habla uno, escucha el otro
      - Si acabo de hablar y le quiero pasar el turno al contrario, le digo "Cambio"
      - Si acabo de hablar y me piro.... no te esfuerces que ya no te escucho: "cambio y corto"
      Esas reglas son las que se llaman protocolo. 

El desarrollo de esas apps cliente servidor se torna cada vez más complejo:
- Desarrollar un cliente (app)
- Desarrollar una app que se ejecute en un servidor (o varias)
- Y un protocolo de comunicación entre ellos.
- Y un lenguaje de comunicación entre ellos.

La web estandariza algunas de las cosas que nos hacen falta en esa comunicación cliente/servidor.
- Me da un lenguaje de comunicación: HTML: HyperText Markup Language
- Me da un protocolo de comunicación: HTTP: HyperText Transfer Protocol
Desde este momento podemos empezar a desarrollar:
- Clientes Web que se acojan a ese protocolo/lenguaje
- Servidores Web que se acojan a ese protocolo/lenguaje

Antiguamente:

    Cliente web (Navegador)         -----> Internet -----> Servidor web (Apache httpd, IIS, Nginx)
        Petición HTTP a una URL                             Ese servidor procesaba la petición:
                                                            Buscaba un archivo HTML en una carpeta del HDD y lo devolvía

Eso facilitó el desarrollo de páginas web.

En un momento dado se pasa del concepto de sitio web al concepto de aplicación web:
- Sitio web: Páginas web estáticas (pre-creadas por un humano)
- App web: Páginas web dinámicas (generadas bajo demanda por un programa)

    Cliente web (Navegador)         -----> Internet -----> Servidor de apps web (IIS, Apache Tomcat, JBoss,
                                                            Wildfly, Glassfish, Liberty, WebSphere, WebLogic)
        Petición HTTP a una URL                             Ese servidor procesaba la petición:
                                                            Solicitar a un lenguaje de programación: PHP, JAVA, ASP, JSP que generase un archivo HTML y lo devolvía

Este concepto, de las apps web triunfó.... pero empezqamos a preguntarnos si nos serviría para resolver otro tipo de problemas:
- Puedo usar esta arquitectura para comunicar otros tipos de aplicaciones:
    App custom en una empresa -----> App custom en otra empresa
    AliExpress                -----> Correos (Nuevo paquete que debes repartir) ---> Datos en una BBDD
                                        ^
                                        Servicio web que se ejecuta en un servidor

Navegador de internet ~= Acrobat reader
         HTML                 PDF

Los navegadores de internet se especializaban en renderizar contenido HTML para que los humanos pudiesemos verlo en pantalla... e interactuar con ello (clic en un enlace)

Ahora bien... puedo seguir usando protocolo HTTP para esto? SI

Eso si... cambio el cliente... y el objetivo del cliente, que ya no es renderizar por pantalla datos para un humano.
Me sigue sirviendo el lenguaje HTML? NO...
HTML es un lenguaje orientado a estructurar contenidos para su visualización por humanos.
    PARRAFO con letra arial de 12px y en negrita
    Lista de elementos con cuadraditos como bullets
    Imagen con borde de 1px y centrada
HTML Es un lenguaje de marcado de PROPOSITO ESPECIFICO (sirve para crear páginas web)
Nos hace falta otro tipo de lenguaje... que se centre en los datos... y en la semantica... no en el formato
HTML es un lenguaje orientado a formato
XML/JSON/YAML son lenguajes orientados a la semantica (significado de cada cosa)

    <pedido>
        <id>109298387</id>
        <fecha>2021-09-23</fecha>
        <cliente>
            <id>123</id>
            <nombre>Pepe</nombre>
            <apellidos>Perez</apellidos>
        </cliente>
        <direccion>
            <calle>Avda. de la Constitución</calle>
            <numero>23</numero>
            <piso>1</piso>
            <puerta>1</puerta>
            <ciudad>Sevilla</ciudad>
            <cp>41001</cp>
        </direccion>
    </pedido>


    {
        "id": 109298387,
        "fecha": "2021-09-23",
        "cliente": {
            "id": 123,
            "nombre": "Pepe",
            "apellidos": "Perez"
        },
        "direccion": {
            "calle": "Avda. de la Constitución",
            "numero": 23,
            "piso": 1,
            "puerta": 1,
            "ciudad": "Sevilla",
            "cp": 41001
        }
    }



    id: 109298387
    fecha: 2021-09-23
    cliente:
        id: 123
        nombre: Pepe
        apellidos: Perez
    direccion:
        calle: Avda. de la Constitución
        numero: 23
        piso: 1
        puerta: 1
        ciudad: Sevilla
        cp: 41001

Igual que para enviar datos por HTML me venía ideal el protocolo HTTP.
Si ahora voy a mandar datos en XML o JSON me podría venir bien usar otro protocolo.
Pero el objetivo era seguir usando HTTP y todas las librerías que teníamos desarrolladas.
Y lo que se hace es montar:
- XML -> Un protocolo nuevo llamado SOAP... que se basa en HTTP
- JSON -> Unas restricciones en el uso de HTTP = REST
            De hecho, REST no fuerza el manejo de documentos JSON... permite también el uso de documentos YAML, XML, HTML... o lo que sea
            Pero... en el 99% de los casos se usa JSON.

---


Crear una plantilla de fichero HTML... donde parte del contenido sea generado por scriptlets php... que un servidor procesa para generar un documento estático HTML que se envía al cliente.

    Cliente web (Navegador)         -----> Internet -----> Servidor de apps web (IIS, Apache Tomcat, JBoss,
                                                            Wildfly, Glassfish, Liberty, WebSphere, WebLogic)
        Petición HTTP a una URL                             Ese servidor procesaba la petición:
                                                            Solicitar a un lenguaje de programación: PHP, JAVA, ASP, JSP que generase un archivo HTML y lo devolvía
---

# Cómo desarrollábamos apps web hace 20 años +-?

1. Montábamos mega-aplciaciones.
   La app hacía de todo: (AMAZON)
    Aplicación que:
        Permitiría a los clientes registrarse, hacer pedidos, a los proveedores dar de alta productos, obtener informes de compras por meses, a los de mensajería ver lo que hay que repartir, abrir disputas... etc.
   Esa aplicación la desplegaríamos en un mega-servidor de aplicaciones (JBOSS, WebSphere, WebLogic)
   Esas apps acababan siendo muy grandes y muy complejas... con muchas interdependencias entre sus partes.
   A primera vista, nos gustó el enfoque... pero a la larga... nos dimos cuenta de que no era lo mejor.... de hecho era una mierda descomunal.
   NO HAY QUIEN MANTENGA ESAS APPS. Su coste de mantenimiento es brutal:
   - Quien sea que toque el código de una parte de la app... tiene que saber como funciona toda la app.
   - A la mínima que toco algo que no debo, todo se va a la mierda.
   - Un cambio puede tener impacto en cualquier parte de la app.
   Montar sistemas complejos centralizados fue una de las peores decisiones que tomamos en el mundo del desarrollo de software.
   A esta forma de diseñar una aplicación se le llama ARQUITECTURA MONOLITICA
   Una cosa es la obtención y preparación de los datos... y otra cosa es la representación de esos datos.
   Y antiguamente, donde todos los clientes eran navegadores web, trabajamos con HTML... y ese HTML lo proveía el servidor de aplicaciones. 
   Mi aplicación debía:
   - Preparar los datos
   - Convertir esos datos en HTML 
   Y cuando aparecen nuevos clientes esta forma de trabajo NO VALE. Necesitamos independizar la obtención y preparación de los datos de la representación de esos datos.
2. Los clientes de esas aplicaciones empezaron a diversificarse.
   En los albores del desarrollo de aplicaciones web, el cliente era un navegador web en todos los casos (años 2000)... pero empezaron a aparecer nuevos clientes:
   - Móviles / Tablets
       Nos permiten montar apps nativas... que ofrecen un nivel de interactividad y de integración con el hardware mucho más alto que el de las apps web.
        Android
        iOS
   - Asistentes de voz: Alexa, Siri, Google Home
   - SmartTVs
   - Sistemas de Voz interactiva
   - Chatbots
   - Cajero automático de un banco
   - Preguntar a cajero (persona) de una sucursal, que tiene su app propia.
   Pregunta: A SIRI le importan 3 huevos el HTML... las negritas, la fuente arial y el borde de 5 px
   Ni al siri, ni a la app nativa android, ni al IOS, ni a sistema de voz interactiva...
   Lo que nos interesa son los datos... y la semántica de esos datos (es decir, saber qué es cada dato)
   Y ya luego... el cliente de turno, representará esos datos como le venga bien: 
    PANTALLA A todo color
    Mediante voz en un altavoz
   EL HTML se nuevo, se me queda pobre... y me hace falta otro lenguaje que me permita representar datos de forma más semántica. 

3. Las aplicaciones controlaban el ESTADO del cliente (SESION del usuario)
   La sesión del usuario era una tabla de datos en memoria RAM, donde mi aplicación guardaba datos relevantes para cada usuario que estuviera conectado al sistema:
    Un usuario accede a una app... rellena un formulario de búsqueda con 4 campos... eso se manda al servidor, que:
    - procesa la consulta
    - devuelve los datos
    - guarda en la sesión del usuario los datos de la consulta, de forma que la siguiente vez que el usuario vaya a la pantalla de la consulta, la app le recuerde los datos que puso la última vez.

   Eso permitía "simplificar" el desarrollo del frontal(cliente)... a costa de qué?
   - Complicar en exceso el desarrollo del backend(servidor) -> Dificulta la mantenibilidad de la app en exceso
   - No ofrece flexibilidad para escenarios alternativos

4. Los componentes que represento en HTML eran nada reutilizables.
    CUIDADO... no hablo solo del HTML (representación de los datos)... 
    Sino también de la lógica asociada a ese trozo de HTML:

        | o   o |   Fermín
        |   x   |   fermin@animalitosfermin.com [v]
        | ----- |   Mandar privado 
                        Asunto:
                        Mensaje:
                        [Enviar]            [OK]

    HTML + CSS + JS

5. Las aplicaciones WEB eran insufribles.
   El nivel de interactividad que ofrecían era muy bajo/nulo.
   Empiezan a surgir nuevas tecnologías que nos permiten montar aplicaciones web más interactivas/más reutilizables/más mantenibles.

    AJAX, Angular, React, Vue... pero esto fue todo RUINA en primeras versiones... Un trabajón insufrible y LENTO DE COJONES!!!
    Hasta que sale: un ESTANDAR: Web components

        NOTA: Hay una organización (w3c) creada por nuestro amigo Tim Berners Lee (WEB: HTTP + HTML) para asegurar
              la evolución del mundo WEB. Define los estándares que seguimos en el mundo del desarrollo web.
                HTML
                HTTP
                CSS
                XML
                XPATH
                SCHEMAS XML
    El estándar Web Components especifica cómo los desarrolladores pueden crear sus propias marcas HTML con su lógica asociada:
        <usuario id="12092"/> Yo puedo crear esta marca
    Y hoy en día los navegadores de internet (que soportan el estandar de WebComponents) me permiten hacer eso de forma nativa... antiguamente tenía que escribir un huevo de código en JS para conseguirlo... tanto
    que empezaron a surgir librerías con todo ese código que me ayudaban a hacerlo: REACT, ANGULAR, VUE...
    Eso si... los navegadores exponen esta funcionalidad mediante un API en lenguaje JS.
    JS no se llama realmente JS... eso era antes... Y no era un lenguaje... sino una colección de lenguajes.
    Su nombre a día de hoy es ECMAScript.... le seguimos llamando JS por costumbre y cariño... pero su nombre es ECMAScript.

    Hoy en día, el HTML que se representa en un navegador se genera dentro del navegador por programas JS que se ejecutan en el navegador.
    Los servidores devuelven JSON y un programa JS en el navegador, coge ese JSON y lo convierte en HTML... que es renderizado en el navegador.

    Angular, REACT, VUE siguen siendo frameworks/librerías de uso cotidianos a día de hoy... pero se han reescrito con respecto a sus versiones iniciales... para hacer uso de el estándar WebComponents.... Mucho del código que antiguamente tenían dentro, hoy en día lo proveen los navegadores de forma nativa.

Cuando empezamos a sufrir todos estos problemas problemas de las arquitecturas monolíticas y formas de trabajo asociadas... empezamos a buscar soluciones.

Significa eso que las arquitecturas monolíticas son malas? NO necesariamente.
Surgen en un momento dado... y en ese momento dado, son la mejor solución que teníamos a los problemas que teníamos en ese momento.

Los problemas evolucionan... y las soluciones deben evolucionar con ellos:
- Lenguajes de programación
- Metodologías de desarrollo
- Arquitecturas de aplicaciones
Todas estas cosas, evolucionan con el tiempo y en paralelo.
No puedo usar una metodología en cascada y hacer una aplicación con una arquitectura de microservicios... porque no me va a salir bien.

Este es el momento en el que surgen las arquitecturas orientadas a servicios/microservicios.

Son arquitecturas diametralmente opuestas a las arquitecturas monolíticas.
Ya no hablamos de aplicación... hablamos de un sistema.
Ese sistema esta compuesto de decenas, cientos o miles de aplicacioncitas (muy simples) que se comunican entre sí.

> SISTEMA DEL BANCO

    Cajero automático                       Login con contraseña (app1)
    Web de banca online                     Login con huella dactilar (app2)
    App nativa Android             >        Consultar el saldo (app3)
                                                    ^
    App nativa iOS                          Hacer una transferencia (app4)
    Sistema de voz interactiva              Login con una tarjeta física (app5)
    Asistente de voz

Voy a tener un montón enorme... aberrante... de aplicaciones... que se comunican entre sí.
Y ya sabemos que para que 2 apps se comuniquen entre si, nos hace falta:
- Protocolo     \
- Canal          > API (Contrato)
- Lenguaje      /

Y parece que los protocolos HTTP nos funcionan bien... los lenguajes JSON/XML también... y los canales... pues... internet. Lo tenemos todo.

Y empezamos a montar esas apps como servicios web y como clientes de servicios web.
A día de hoy, los APIs REST son el estándar de facto para el desarrollo de aplicaciones web.

En REST además se tiene en cuenta otra cosa:
- Las comunicaciones se realizan con protocolo HTTP (usando solo una parte de las funcionalidades que ofrece HTTP)
- El lenguaje de comunicación es JSON (aunque podría ser XML, YAML, HTML... o lo que sea)
- Se tiene en cuenta el concepto de recurso (cada concepto que maneja la app es un recurso)
- Cada recurso tiene una URL asociada, que lo identifica de forma única
---

Montar una aplicación es bien fácil. Es solo cuestión de tiempo y dinero.
El problema no está en montar una aplicación... el problema está en mantenerla.
Y hay aplicaciones cuyo mnto. es más alto que reescribirlas desde 0. Y ESTO OCURRIA CON MUCHA MAS FRECUENCIA DE LA QUE NOS GUSTARÍA.

Un buen diseño/arquitectura nos permite desarrollar una app que sea fácil de mantener y de evolucionar en el futuro. Y ESTA ES LA CLAVE. Y ESTO ES LO A LAS EMPRESAS LES HA COSTADO UN PASTIZAL ENTENDER.


----

> EJEMPLO PRACTICO: Tienda virtual de Animalitos Fermín

CLIENTES (formas de acceso a su tienda)       FUNCIONALIDADES
    Navegador web                             Que animalitos hay en venta
        app web (renderizar HTML)       json    Servicio: http://animalitosfermin.com/animalitos [GET]
            Esa app la montaríamos con JS
    Teléfono móvil Android                    Conocer el detalle de un animalito
        app Kotlin                      json    Servicio: http://animalitosfermin.com/animalitos/pipo [GET]
                                                Servicio: http://animalitosfermin.com/animalitos/flupi
    Teléfono móvil iOS                        Dar de alta un animalíto nuevo que se vende
        app Swift                               Servicio: http://animalitosfermin.com/animalitos [POST]
    Asistente de voz                          Comprar un animalito
        app Siri
        app Alexa
    Número de teléfono
        app IVR
    App escritorio Windows
       usada por lo empleados en las tiendas físicas

                                               Servicio text-to-speech: 
                                               GOOGLE: http://translate.google.com/translate_tts?tl=es&q=Pipo
                                                    WAV ... que cuando se reproduce dice: Pipo, con acento español

TIPOS DE RECURSOS: Animalitos
RECURSOS CONCRETOS: Pipo, Perico, Flupi, Lolo

---

# Principio de desarrollo de software: SOLID

Un conjunto de PRINCIPIOS que nos ayudan a desarrollar software fácil de mantener y de evolucionar.
- S: Single Responsability Principle
        Cada componente de mi aplicación debe tener una única responsabilidad.
- O: Open/Closed Principle
        Mi aplicación debe estar abierta a la extensión... pero cerrada a la modificación.
- L: Liskov Substitution Principle
        Si tengo un componente que hereda de otro... puedo sustituir el componente padre por el hijo sin que la aplicación se entere.
- I: Interface Segregation Principle
        Mejor muchas interfaces de propósito específico que una interfaz de propósito general.
- D

---

# Métodos o verbos HTTP

Cuando se hace una petición por HTTP, a una URL, se pasan una serie de metadatos. 
Uno de esos metadatos es el método HTTP que se va a usar:
- GET       -> Obtener datos del servidor
- POST      -> Crear datos en el servidor
- PUT       -> Modificar datos en el servidor
- DELETE    -> Borrar datos en el servidor
- PATCH     -> Modificar parcialmente datos en el servidor
- HEAD      -> Saber si un recurso existe en el servidor

http://animalitosfermin.com/animalitos/pipo
    GET     -> Obtener los datos de pipo
    HEAD    -> Saber si pipo existe
    DELETE  -> Borrar a pipo
    PUT     -> Modificar los datos de pipo

---

# Versiones de software

1.2.3

                ¿Cuándo cambian?
    MAJOR 1     Breaking changes / Cambios que implican NO RETRO-COMPATIBILIDAD
                    Cambio en las APIs: SI QUITAN COSAS
                    Cambio en los formatos de ficheros de almacenamiento de datos que uso
    MINOR 2     Nueva funcionalidad
                Funcionalidad marcada como deprecated (obsoleta)
                    + solución de errores
    PATCH 3     Solución de errores (bugsfixes)


---

Clientes                              Servicios
                                        SERVICIO DE ANIMALITOS v1.3.0 (OBSOLETA)
    app web      v1.2.0                    GET http://animalitosfermin.com/animalitos
    app android  v1.2.0                    POST http://animalitosfermin.com/animalitos
    app ios      v1.2.0                    GET http://animalitosfermin.com/animalitos/pipo
    app siri                               PUT http://animalitosfermin.com/animalitos/pipo
    app alexa                              DELETE http://animalitosfermin.com/animalitos/pipo
    app ivr                             SERVICIO DE CLIENTES   v1.0.0
    app windows  v1.2.0                    GET http://animalitosfermin.com/clientes
                                           POST http://animalitosfermin.com/clientes
                                           GET http://animalitosfermin.com/clientes/pepe
                                           PUT http://animalitosfermin.com/clientes/pepe
                                           DELETE http://animalitosfermin.com/clientes/pepe
                                        SERVICIO DE ANIMALITOS v2.0.0
                                           GET http://animalitosfermin.com/v2/animalitos
                                           POST http://animalitosfermin.com/v2/animalitos
                                           GET http://animalitosfermin.com/v2/animalitos/pipo
                                           PUT http://animalitosfermin.com/v2/animalitos/pipo
                                           DELETE http://animalitosfermin.com/v2/animalitos/pipo

En v1.0.0, los animalitos tienen:
    - Nombre
    - Especie
    - Raza
    - Precio
    - Descripción
    - Edad

Los "ANIMALITOS" es un tipo de recurso que se maneja en el sistema.
Cómo llamamos a estos tipos de recursos: ENTIDADES (atributos o propiedades)

> CAMBIO 1
Me está dando muchos dolores de cabeza el guardar la edad.... hay que irla modificando de continuo.
Quiero que ahora los animalitos tengan también fecha de nacimiento.

Tengo que montar una versión nueva de qué aplicación? tengo un huevo?
    SERVICIO DE ANIMALITOS v1.0.0 -> v1.1.0
        No quito la edad... solo la quito de la BBDD.
        Ahora guardo la fecha de nacimiento...y la edad la calculo en el momento de la petición.
        En los que exportan datos: GET saco tanto edad como fecha de nacimiento
        En las funciones de entrada de datos: POST/PUT:
            edad -> OBSOLETA   (Si me pasan edad, pongo como fecha de hacimiento: HOY - EDAD)
            fecha_nacimiento -> NUEVO (Si se pasa se ignora la edad... sino la edad es obligatoria)

Pregunta? Subo la versión a producción? o me espero a que los clientes modifiquen sus pantallas para que muestren/capture la fecha de nacimiento?
    Como tenga que esperar ... esto no sale en la vida!
    ESTO ES LO QUE PASABA con los sistemas monolíticos... que no podíamos evolucionarlos con facilidad.
No espero a nadie... subo el cambio en cuanto lo tengo listo: METODOLOGIAS AGILES

> CAMBIO 2
Quiero meter otro cambio.
Quiero poder subir fotos de los animalitos

Sería exactamente igual que el cambio anterior... pero con una versión nueva (MINOR)
v1.1.0 -> v1.2.0

> CAMBIO 3
Me he dado cuenta que el mundo va más rápido que yo... y que lo de las fotos.. esta un poco obsoleto.
Eres un boomer!!!!
Queremos videos de los animalitos.
O lo que surja... audio.
Debemos poder asociar binarios a los animalitos... junto con un tipo de binario.

Servicio de animalitos v1.2.0 -> v2.0.0 (BREAKING CHANGE)
    Antes:                                  Ahora:
        {                                        {
            nombre": "Pipo",                       "nombre": "Pipo",
            "especie": "Perro",                    "especie": "Perro",
            "raza": "Labrador",                    "raza": "Labrador",
            "precio": 300,                         "precio": 300,
            "descripcion": "Un perro muy bonito",  "descripcion": "Un perro muy bonito",
            "fecha_nacimiento": "2019-01-01",      "fecha_nacimiento": "2019-01-01",
            "fotos": [                             "multimedia": [
                "http://animalitosfermin.com/fotos/pipo1.jpg",    {
                "http://animalitosfermin.com/fotos/pipo2.jpg",        "tipo": "foto",
                "http://animalitosfermin.com/fotos/pipo3.jpg"         "url": "http://animalitosfermin.com/fotos/pipo1.jpg"                                  },
            ]                                                     {
                                                                   "tipo": "foto",
                                                                    "url": "http://animalitosfermin.com/fotos/pipo2.jpg"
                                                                  },
                                                                  {
                                                                    "tipo": "foto",
                                                                    "url": "http://animalitosfermin.com/fotos/pipo3.jpg"
                                                                  }
                                                                 ]
Pregunta... subo la versión v2.0.0 a producción?
    Pero si lo subo... reemplazando la v1.2.0 los clientes dejan de funcionar.
    Pero quiero subirlo... Subo las 2... y dejo un tiempo para que los clientes se actualicen.
    La versión 1.2.0 queda obsoleta... pero disponible durante un tiempo.
Sería el único cambio?
Donde se guardan los datos de la v2? En una BBDD
Y los de la v1? En la misma BBDD
Pero en la estructura de tablas que tenía en V1... me entran los datos que quiero en V2?
    V1     animalitos -< fotos
    V2     animalitos -< multimedia >- tipo
Si quiero tener una única fuente de datos (EVIDENTEMENTE QUIERO) y que la V1 sea capaz de seguir usando la BBDD ya actualizada a V2.... necesito cambiar también el código de v1 -> v1.3.0

Para que todo esto sea posible, los APIs se convierten en algo fundamental.
Cada versión de mis servicios debe tener un API asociado.... y publicado... y documentado.
Y debo tener muy claro que cada versión de mi servicio es un contrato que hago con mis clientes.
Que respetaré... y que no cambiaré sin avisar (deprecated) y sin dejar tiempo para que los clientes se actualicen.

---
# Metodología ágil

Entregar el producto de forma incremental y evolutiva.


---

# Servicio de animalitos de fermín.
Da igual el lenguaje de programación... que conceptos (clases, interfaces) voy a manejar?

 GET http://animalitosfermin.com/animalitos
 POST http://animalitosfermin.com/animalitos
 GET http://animalitosfermin.com/animalitos/pipo
 PUT http://animalitosfermin.com/animalitos/pipo

Datos: ENTIDADES
    Animalito
    AnimalitoMultimedia

Quién se encarga de persistir esas entidades en la BBDD: AnimalitosRepository
                                                            persistirAnimalito(Animalito)
Donde se define la función altaDeAnimalito?
En mi negocio, implica: Persitir el animalito en la BBDD, Mandar un email a todos los clientes suscritos, mandar otro email a los empleados, avisándoles. Conectar con un servicio de mensajería para concertar cita con el veterinario.

Donde se añade la lógica de negocio? En un Servicio

Ese servicio será accesible directamente desde HTTP/REST? Este es mi servicio WEB: NO

Ese servicio lo expondré mediante distintos protocolos: 
    REST v1/v2
    SOAP
    RPC

Aquí nos salen las:
Arquitecturas limpias, hexagonales, en cebolla... que nos ayudan a crear diseños fáciles de mantener y de evolucionar.