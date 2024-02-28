# Seguridad

## Protocolo https

Es una extensión del protocolo http al que se añade una capa de seguridad. Esta capa de seguridad se basa en el protocolo SSL/TLS.

Que nos ofrece esa capa?
- Frustrar los ataques de tipo MAN IN THE MIDDLE: Cifrado
- Ayudarnos a frustrar los ataques de suplantación de identidad: Phishing
  Certificado (clave pública) y el servidor tiene la clave privada. 
+ Opcionalmente... si usamos SSL doble, nos ayuda a verificar la identidad (autenticación) del cliente.
  Esto es poco habitual: Página de Hacienda, Seguridad Social, etc. 

## Más habitual es que la autenticación de cliente se haga por otros medios:

- Contraseña
- Factor de doble autenticación
- Características biométricas

## Oauth

El protocolo más utilizado para autenticación de terceros.

Antaño, las aplicaciones gestionaban las contraseña de los usuarios.
Yo no soy un experto en seguridad... ni remotamente.
Además es algo que se hace en todos los proyectos.

Una contraseña NUNCA SE GUARDA EN UNA BBDD. Se guarda un hash de la contraseña.
Un hash que no permite reproducir la contraseña.
Herramientas que gestionan bien la seguridad como KeyCloak guardan 1024-32.000 iteraciones del hash.

Mis aplicaciones autentican a clientes mediante un PROVEEDOR DE IDENTIDAD: KeyCloak, Google, Facebook, github, Microsoft active directory, LDAP, etc.

Hay 2 protocolos que se usan mucho para comunicarse con ese tipo de sistemas: Oauth y SAML.

- SAML es un protocolo de autenticación de terceros.
- Oauth es un protocolo de autenticación y autorización de terceros.

---

Humano  Navegador           Servidor web frontal        Servidor Backend        Proveedor de identidad
          HTML     JS

Lucas   https://app1.com --->
                         <--- Devuelve un html y uno js
            <----  Se ponen a generar + HTML
Quiero ver mis facturas
         click ---> Ah si??? y tu quien eres? npi
          <------  300 redirect a proveedor de identidad.. donde añade información de quién es él (APP1)
          ---------------------------------------------------------------------> App1? Ah si... la conozco..
          <-------------- formulario de login ---------------------------------- dime quien eres?
rellena los datos
          ---------- post -----------------------------------------------------> Verifica los datos
                                                                    Prepara un token JWT: Json Web Token
                                                                    Dentro va: 
                                                                        - Quién es el usuario
                                                                        - Quién es el proveedor de identidad
                                                                        - Firma digital del proveedor de identidad
                                                                        - app1
                                                                        - Cuándo caduca
                                                                        - Qué roles tiene
          <------------------ 300 redirect a la app1... adjuntando el token JWT--
          --------> El JS Lee el token. Normalmente hace 1 primera validación del Token.
                    Se suele hacer una validación ligera.
                    Luego se hace una validación más profunda en el backend.
                    Con esa firma se mira si el token es válido... aparentemente.
                        Lo que no se mira es que el token haya sido revocado!
                        Miro solo la caducidad... sino hago demasiadas peticiones al proveedor de identidad
                        y hago la app demasiado lenta.
                  Ah, es federico... vamos a pedir al Bend sus facturas

                    CORS: Cross Origin Resource Sharing
                    Esto es una comprobación que hacen los NAVEGADORES DE INTERNET
                    El js pide al navegador ir al servidor de backend
                    El navegador le pregunta al servidor de backend... oye, desde este dominio: https://app1.com, te pueden pedir cosas? El backend contesta... si, le dejo.
                    Esto es para evitar que una página maliciosa pida cosas a un servidor de backend. MENTIRA.
                        Es una medida adicional de protección. NO ES SUFICIENTE... no es obligatoria.
                  --------------token--------------------> Dame las facturas de federico
                                                           Y tu quien eres para pedir las facturas de federico?
                                                           En la petición se incluye información del cliente
                                                           Sabiendo que es la app1, mira el token del usuario

                                                           Revisa el token... la firma... y la fecha. 
                                                           Y le pregunta al proveedor de identidad... oye, este token es válido? o está revocado?
                                                            ---ID de cliente ---> 
                                                                                 Y tu quien eres para preguntarme a mi...?
                                                                                 Soy el Bend
                                                                                 Autenticate!
                                                                                    Certificado
                                                                                    Secreto compartido
                                                                                 Ah... es verdad, eres el Bend
                                                                                 Pues entonces dejame ver si el token es válido
                                                            <--------------------  SI
                                                            Sabiendo que es válido, mira los roles del usuario
                                                            que vienen dentro del JWT.
                                                            Y decide si le deja o no ver las facturas: SI tiene permiso para verlas.
                   <--------------------------------------- Prepara el listado, lo empaqueta en JSON
                   se convierta a HTML
         <--------
Pueda ver con sus ojos las facturas

Humano  Navegador           Servidor web frontal        Servidor Backend        Proveedor de identidad
          HTML     JS

---

# Proveedores de Identidad

Controlan:
- usuarios... de cada usuario guardan metadatos (nombre, apellidos, email, etc)
              y formas de autenticación (contraseña, huella, teléfono, etc)
- aplicaciones... de cada aplicación guardan metadatos (nombre, logo, etc) 
                y formas de autenticación (secreto, certificado, etc)
                y los roles / scopes que tiene la aplicación
- roles... y a cada usuario se le asignan esos roles. Esos roles pueden ser específicos de la aplicación o globales.
- scope. 
  Un scope representa el conjunto de metadatos que se le permite a una aplicación ver de un usuario.
  Una aplicación puede tener varios scopes.
    básico
    extendido

    Para ciertas operaciones en mi app, la aplicación solicitará login al proveedor de identidad.
    Pero quizás solicita login con un scope básico.
    Pero para otras operaciones, la app puede necesitar más datos del usuario.... y solicita login con un scope extendido.

    Si quiero permisos a nivel de entidad, necesito una tabla en mi app que me diga qué usuario tiene qué permisos para qué entidades.

    ROLES: Es un conjunto de permisos.
    ACL: Access Control List: (como en linux, los permisos de un archivo: USUARIO, GRUPO, OTROS)
        A cada recurso le asigno una serie de usuarios que pueden acceder a él.
            Los animalitos de Madrid pueden ser Leidos por: Federico, los usuarios con role Administrador
            Los animalitos de Madrid pueden ser Editados por: Federico
            Los animalitos de Madrid pueden ser Borrados por: los usuarios con role Administrador

En ocasiones, vamos a tener clientes que no son usuarios... sino otras aplicaciones/servicios.
El procedimiento es el mismo... pero en lugar de un usuario, se autentica una aplicación mediante el proveedor de identidad (Certificado, secreto compartido, etc)

---
# Formas de comenzar a implementar un Servicio Web:

- Comenzar por capa de dominio          DOMAIN DRIVEN DESIGN
- Comenzar en capa de negocio
- Comenzar en capa de controlador       API FIRST
- Diseño del api                        API DESIGN FIRST

---

# Ejemplo de implementación de servicio web

Os comenté que las arquitecturas evolucionan en paralelo con las metodologías de desarrollo de software, con los lenguajes y con las herramientas.

Tenemos en proyecto de Servicio de Animalitos de la tienda virtual de Fermín.
Lo vamos a montar en JAVA... y lo haremos con Spring Boot.

Spring: Framework de Java de inversión de control de código.

## Inversión de control: 

YO dejo de controlar el flujo de ejecución del programa, para delegarlo en el framework.
Para qué quiero inversión de control? Para ayudarme a realizar Inyección de Dependencias.

## Inyección de Dependencias:

Patrón de diseño que permite que una clase no cree instancias de objetos que necesita... sino que le sean suministradas.
Para qué quiero esto?
- Para poder hacer pruebas unitarias de mi código. NO PUEDO HACER PRUEBAS UNITARIAS DE MI CÓDIGO SI TENGO DEPENDENCIAS FUERTES.
- Para respetar el principio de inversión de dependencias.

## Principio de inversión de dependencias:

Las clases de alto nivel no deben depender de las clases de bajo nivel. Ambas deben depender de abstracciones.

---
Quiero montar una app de consola que me permita buscar palabras en diccionarios de idiomas... y darme los significados si existen.

    $ diccionario ES manzana
    Fruta del manzano

> Repos de git: Proyectos independientes... con su archivo maven independiente.

                                    RESPONSABILIDAD
FRONTAL DE CONSOLA                  Mostrar datos por pantalla
API del BACKEND                     Expone como comunicarse con el backend de turno
BACKEND que controla diccionario    Gestionar diccionarios
                                        Buscar palabras
                                        Mostrar significados
> API del BACKEND: diccionario-api.jar

    package com.diccionario;

    interface Diccionario {
        boolean existe(String palabra);
        Optional<List<String>> getSignificados(String palabra);
    }
    interface SuministradorDeDiccionarios {
        boolean tienesDiccionarioDe(String idioma);
        Optional<Diccionario> getDiccionario(String idioma);
    }
    // API CERRADO !... lo empaqueto a un archivo jar

> Frontal de consola: diccionario-console.jar
    import com.diccionario.*;
    // import com.diccionario.impl.*; // Y YA LA HE CAGAO... EL PROYECTO HA MUERTO !
    // Me acabo de cagar en el principio de inversión de dependencias

    public class App{
        public static void main(String[] args) {
            ...// Flujo del programa
            Spring... ejecutame esta aplicación.
                Necesito que llames al método procesarPeticion
        }
        public void procesarPeticion(String idioma, String palabra, SuministradorDeDiccionarios miSuministrador) {
            // HARE COSITAS...
            //SuministradorDeDiccionarios miSuministrador = new SuministradorDeDiccionariosDesdeFicheros();
            if(miSuministrador.tienesDiccionarioDe(idioma)) {
                Diccionario miDiccionario = miSuministrador.getDiccionario(idioma).get();
                if(miDiccionario.existe(palabra)) {
                    Optional<List<String>> significados = miDiccionario.getSignificados(palabra);
                    if(significados.isPresent()) {
                        for(String significado: significados.get()) {
                            System.out.println(significado);
                        }
                    } else {
                        System.out.println("No se encontraron significados para la palabra: " + palabra);
                    }
                } else {
                    System.out.println("La palabra: " + palabra + " no existe en el diccionario");
                }
            } else {
                System.out.println("No existe diccionario para el idioma: " + idioma);
            }
        }
    }
    En el pom... mi proyecto tiene dependencia con diccionario-api.jar

> Implementación del backend: diccionario-desde-ficheros-impl.jar
    
    package com.diccionario.impl;
    
    import com.diccionario.*;

    public class DiccionarioDesdeFicheros implements Diccionario {
        public boolean existe(String palabra) {
            ...
        }
        public Optional<List<String>> getSignificados(String palabra) {
            ...
        }
    }
    public class SuministradorDeDiccionariosDesdeFicheros implements SuministradorDeDiccionarios {
        public boolean tienesDiccionarioDe(String idioma) {
            ...
        }
        public Optional<Diccionario> getDiccionario(String idioma) {
            ...
        }
    }

    Proyecto cerrado... lo empaqueto a un archivo jar: diccionario-desde-ficheros-impl.jar
    En el pom.xml de este proyecto (el archivo de configuración de maven) le pongo una dependencia con 
    diccionario-api.jar

    app.jar > diccionario-api.jar < diccionario-desde-ficheros-impl.jar


# Ejemplos

# ReadyAPI


---

# Pruebas de rendimiento

Hay factores que no controlo:
- Latencia de red
- Estado de un router

Jugamos a percentiles.
El 95% de las peticiones tienen que tardar menos de 1 segundo.

Hago varias pruebas.
- La primera: Es para determinar la linea base. (1 peticion, secuancialmente 1000 veces)
  Media del las peticiones inferiores al %95
  Tomo el 95% de las peticiones que menos tardan... y calculo su media 

  Mejor tiempo que este no lo voy a tener. DESARROLLO
- A media carga: Lanzo lo mismo pero muchos a la vez. La mitad de lo que espero en pico
  Debería de haber poca / nada degradación del tiempo calculado en linea base
  El problema mas que en desarrollo está en configuración del entorno.
- A carga máxima: Lanzo lo mismo pero muchos a la vez. 
  Debería de haber algo de degradación del tiempo calculado en linea base pero poco
- A doble de carga máxima: Lanzo lo mismo pero muchos a la vez. 
  Debería de haber bastante degradación del tiempo calculado en linea base
  Me sirve para obtener experiencia