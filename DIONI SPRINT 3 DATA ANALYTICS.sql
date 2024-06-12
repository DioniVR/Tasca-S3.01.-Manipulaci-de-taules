/* - Exercici 1
La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit.
La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres 
dues taules ("transaction" i "company"). Després de crear la taula serà necessari que ingressis la informació del document 
denominat "dades_introduir_credit". Recorda mostrar el diagrama i realitzar una breu descripció d'aquest*/

# Creamos la tabla credit_Card

CREATE TABLE  credit_card ( 

Id VARCHAR(15) PRIMARY KEY,  

Iban VARCHAR(40) NOT NULL UNIQUE,  

Pan VARCHAR(30) NOT NULL,

Pin INT NOT NULL,  

Cvv INT NOT NULL,  

expiring_date  VARCHAR(10) NOT NULL,

Update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP

); 



/*Hemos creado el 

/*Ahora tenemos que indicar que el campo credit_card_id de la tabla transactions, será una foreign key de la tabla credit_Card.
 Eso lo haremos mediante el siguiente comando */

ALTER TABLE transaction 
ADD  CONSTRAINT FK_Credit_card FOREIGN KEY (credit_card_id) REFERENCES credit_card (Id);

/***************************CORRECCIONES *********************************/

# VAmos a hacer un cambio en los campos CVV y PIN para que los mismos pase a ser VARCHAR

ALTER TABLE credit_card
MODIFY CVV VARCHAR(3) NOT NULL;

ALTER TABLE credit_card
MODIFY PIN VARCHAR(4) NOT NULL;

# Para ver que se los datos se han grabado correctamente:

DESCRIBE credit_Card;
/******************************************************************/

/*- Exercici 2 
El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb ID CcU-2938. 
La informació que ha de mostrar-se per a aquest registre és: R323456312213576817699999. Recorda mostrar que el canvi es va realitzar. */



# Miramos la información que tiene el usuario

SELECT * FROM credit_Card
WHERE id ="CcU-2938";

# Cambiamos la información con el comando UPDATE

UPDATE credit_Card
SET Iban = "R323456312213576817699999", Update_date = current_timestamp()
WHERE id = "CcU-2938";

/*Excercici 3: 
En la taula "transaction" ingressa un nou usuari amb la següent informació:

Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
credit_card_id	CcU-9999
company_id	b-9999
user_id	9999
lat	829.999
longitude	-117.999
amount	111.11
declined	0*/

# Usamos el comando INSERT para incluir el nuevo registro con los datos solicitados


INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) 
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD',' CcU-9999', ' b-9999', '9999', '829.999', ' -117.999','111.11','0'); 

SELECT * FROM TRANSACTION;

/************************************CORRECCION **************************************************************/
/*Obtenemos un error. Ese error se debe a que el nuevo registro que queremos introducir tiene tres campos (“credit_card_id”, “company_id” y “User_id”)
 que no existen en las tablas maestros. Procederemos deshabilitar temporalmente las foreign key, insertar el registro y
 volver a insertar las foreign key*/
 

ALTER TABLE transaction
DROP FOREIGN KEY transaction_ibfk_1;

ALTER TABLE transaction
DROP FOREIGN KEY FK_Credit_card;

ALTER TABLE TRANSACTION
DROP FOREIGN  KEY “FK_User_id”;

ALTER TABLE TRANSACTION
DROP PRIMARY KEY;

#Volvemos a insertar de nuevo el registro

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) 
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD',' CcU-9999', ' b-9999', '9999', '829.999', ' -117.999','111.11','0');

#consulta para ver que se ha grabado

select * from transaction
where id = "108B1D1D-5B23-A76C-55EF-C568E49A99DD";

#Ahora tenemos que volver a insertar todas las foreign keys en la tabla transaction


ALTER TABLE TRANSACTION
ADD CONSTRAINT FK_Company FOREIGN KEY (company_id) REFERENCES company(id);

ALTER TABLE TRANSACTION
ADD CONSTRAINT FK_Credit_card FOREIGN KEY (credit_card_id) REFERENCES credit_card(Id);

ALTER TABLE TRANSACTION
ADD CONSTRAINT FK_User_id FOREIGN KEY (user_id) REFERENCES data_user(id);

ALTER TABLE TRANSACTION
ADD PRIMARY KEY (id);

/*********************************************************************/

/*- Exercici 4
Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_*card. Recorda mostrar el canvi realitzat.*/

# Esto lo haremos con el comando ALTER TABLE DROP.

ALTER TABLE credit_card
DROP COLUMN PAN;

SELECT * FROM credit_Card;

/*Nivell 2*/

/*Exercici 1
Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.*/

# Primero tenemos que localizar la transacción.

SELECT * FROM transaction
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

#Borraremos dicha transacción con el el statement delete. Hay que tener en cuenta no olvidar incluir una clausula
#WHERE donde indiquemos el ID que queremos eliminar. De lo contrario, borraremos todos los registros de la tabla.

DELETE FROM TRANSACTIONS.transaction
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

# Antes de borrar hay 587 registros. Al borrarlo deberemos obtener 586.

SELECT * FROM transaction; # aparecen 586 registros.


#Al buscar de nuevo la tranacción ya no debe aparecer
SELECT * FROM transaction
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";  #  Obtenemos NULL.

/*Exercici 2
La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives.
S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions.
Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: 
Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.*/ 

/* Tendremos que unir las tablas Transactions y Company con un JOIN, filtrar el campo decline para que sólo muestre las transacciones realizadas
 agrupamos los datos por Nombre de Companía, Teléfono y País y calcular el importe promedio de las ventas.
Finalmente, guardaremos los datos en una vista*/

CREATE VIEW VistaMarketing AS
SELECT company.company_name , company.phone , company.country , AVG(transaction.amount) AS Sales_Average
FROM transactions.transaction
LEFT JOIN transactions.company
ON transaction.company_id = company.id
WHERE transaction.declined = 0
GROUP BY company.company_name , company.phone , company.country
ORDER BY 4 DESC;

/******************************************** CORRECCIÓN ******************************/

#para elimiminar el order by de la view Vistamarketing la he modificado con el siguiente comando

CREATE OR REPLACE VIEW VistaMarketing AS
SELECT company.company_name , company.phone , company.country , AVG(transaction.amount) AS Sales_Average
FROM transactions.transaction
LEFT JOIN transactions.company
ON transaction.company_id = company.id
WHERE transaction.declined = 0
GROUP BY company.company_name , company.phone , company.country;

#Hacemos la consulta que nos piden

SELECT * FROM vistamarketing
order by 4 desc;



SELECT * FROM vistamarketing
order by 4 desc;

/*********************************************************************************/

/*Exercici 3
Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"*/

#Haremos una consulta usando la vista "Vistamarketing" como si fuera una tabla más y filtrando por país = "Germany"

SELECT *
FROM vistamarketing
WHERE country = "Germany";

#Nivell 3
/*Exercici 1
La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. Un company del teu equip va realitzar modificacions 
en la base de dades, però no recorda com les va realitzar. Et demana que l'ajudis a deixar els comandos executats per a obtenir
 el següent diagrama"*/
 
 /*1 Primero creamos los la tabla user según el fichero txt y añadimos los datos. Segundo, tenemos que eliminar la restricción de
 foreign key en el campo "Id" ya que no aplica. El campo ID es una primary Key.*/
 
ALTER TABLE user 
DROP FOREIGN KEY user_ibfk_1;

/*Cuando mi compañero creo la constraint foregin key no le asignó ningún nombre. Pero automáticamente el sistema
le ha puesto el nombre "user_ibfk_1".*/

/*2_ El siguiente paso es eliminar el indice de la tabla Transaction llamado idx_user_id*/

ALTER TABLE transaction 
DROP INDEX idx_user_id; 

/*Ahora tenemos que convertir el campo “user_id” de la tabla Transaction en una foreign key relacionada con la tabla user 
 recientemente creada*/

 
ALTER TABLE TRANSACTION 
ADD CONSTRAINT “FK_User_id” FOREIGN KEY (user_id) REFERENCES user(id);


/*3 - El campo ID de la tabla credit_card lo hemos creado como VARCHAR(15) pero ha de ser   VARCHAR(20).
 Modificarmos estos con los siguientes comandos. */

 
ALTER TABLE credit_Card
MODIFY COLUMN Id VARCHAR(20);


/*4 - El campo Iban de la tabla credit_card lo hemos creado como VARCHAR(40) pero ha de ser   VARCHAR(50).
 Modificarmos estos con los siguientes comandos. */

 ALTER TABLE credit_card 
MODIFY COLUMN  Iban VARCHAR(50);

 

/*5- El campo pin de la tabla credit_card lo hemos como INT pero ha de ser   VARCHAR(4).
 Modificarmos estos con los siguientes comandos. */

 
ALTER TABLE credit_card 
MODIFY COLUMN  pin VARCHAR(4);

 
/*6 – El campo fecha_actual de la tabla credit_card lo hemos creado como TIMESTAMP pero ha de ser DATE */

#Primero cambiamos el nombre de la columna 

ALTER TABLE credit_card 
RENAME COLUMN UPDATE_DATE TO  FECHA_ACTUAL;

#Segundo cambiamos el tipo de datos  de TIMESTAMP a DATE

ALTER TABLE credit_card 
MODIFY COLUMN fecha_actual DATE;

/*7 – Tenemos que cambiar el nombre de la tabla User a Data_User */

RENAME table user TO Data_User; 

select * from data_user;

/*************************CORRECCIONES*****************************/

# 8 Se nos pide que cambiemos el nombre de la columna email de la tabla data_user por personal_email.

ALTER TABLE data_user
RENAME COLUMN email TO personal_email;

select * from data_user;

# 9 Eliminamos la columna website

ALTER TABLE COMPANY
DROP COLUMN WEBSITE;

SELECT * FROM company; 
/*********************************************************/





/*Exercici 2
L'empresa també et sol·licita crear una vista anomenada "InformeTecnico" que contingui la següent informació:
ID de la transacció
Nom de l'usuari/ària
Cognom de l'usuari/ària
IBAN de la targeta de crèdit usada.
Nom de la companyia de la transacció realitzada.
Assegura't d'incloure informació rellevant de totes dues taules i utilitza àlies per a canviar de nom columnes segons sigui necessari.
Mostra els resultats de la vista, ordena els resultats de manera descendent en funció de la variable ID de transaction.*/

/* Tendremos que unir las tablas Transactions y Company con un JOIN, selecionamos los campos requeridos y además añadimos el país y el importe
de la comprar porque me parecen datos relevantes.  Finalmente, guardaremos los datos en una vista.*/


CREATE VIEW InformeTecnico AS
SELECT  transaction.id AS ID_Transaccio,  data_user.name AS Nom_usuari, data_user.surname AS Cognom,  
credit_card.Iban as IBAN, company.company_name AS Company_name,transaction.amount AS Importe_compra ,company.country AS PAIS
FROM transactions.transaction
LEFT JOIN transactions.company
ON transaction.company_id = company.id
LEFT JOIN transactions.data_user
ON transaction.user_id = data_user.id
LEFT JOIN transactions.credit_card
ON transaction.credit_card_id = credit_card.Id
ORDER BY 1 DESC;

SELECT * FROM informetecnico;

#1956




 


