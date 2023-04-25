--1 Conectarse a Oracle con su usuario USER_ADMIN.

--2 Listar los registros de la tabla PERSONA
    select * from persona;
    
--3 Utilizando la tabla PERSONA listar los registros de vendedores según lo solicitado:
    select 
     (UPPER(apeper)||',' ||' '|| nomper) as PERSONA,
     dniper as DNI,
     celper as CELULAR,
     REGEXP_SUBSTR(emaper,'em[^+]*') as SERVIDORCORREO
    from persona 
    where tipper = 'V';
    
--4 El VENDEDOR de ID 200 tiene como fecha de nacimiento 03-NOV-67 y el VENDEDOR  de ID 203 tiene como fecha de nacimiento 25-MAR-73, actualizar las fechas de nacimiento de los vendedores.
    update persona 
    set fecnacper = '03-Nov-1967'
    where tipper = 'V' and idper = 200;
    
    update persona 
    set fecnacper = '25-Mar-1973'
    where tipper = 'V' and idper = 203;
    
    select 
    idper as ID,
    (UPPER(apeper)||',' ||' '|| nomper) as PERSONA,
    emaper as EMAIL,
    fecnacper as FechaNacimiento
    from persona 
    where tipper = 'V';
    
--5 El VENDEDOR Alberto Solano ha renunciado a la EMPRESA, por tanto hay que darle de baja.
    update persona 
    set estper = 'I'
    where tipper = 'V' and idper = 200;
    
    select 
    nomper as PERSONA,
    UPPER(apeper) as APELLIDOS,
    dniper as DNI,
    estper as ESTADO
    from persona 
    where tipper = 'V';
    
--6 Listar datos de los vendedores especificando día y mes de su cumpleaños.
    SELECT 
     NOMPER AS PERSONA,
     APEPER AS APELLIDOS,
     DNIPER AS DNI,
     TO_CHAR(FECNACPER, 'DD-Month') AS CUMPLEAÑOS
    FROM PERSONA
    WHERE TIPPER='V';
    
--7 Calcular la edad de los vendedores y clientes.
    select
    (apeper||',' ||' '|| nomper) as PERSONA,
    emaper as Email,
    TRUNC( ( TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')) -  TO_NUMBER(TO_CHAR(persona.fecnacper,'YYYYMMDD') ) ) / 10000) AS Edad
    from persona;

--8 Obtener la cantidad de personas que cumplen años en el primer y segundo semestre.
    --test FULL OUTER JOIN
    SELECT
    COUNT(to_char (fecnacper, 'mm')) as "1er SEMESTRE"
    FROM PERSONA WHERE to_char (fecnacper, 'mm') <=6 ;
       --LEFT JOIN         
    SELECT
    COUNT(to_char (fecnacper, 'mm')) as "2er SEMESTRE"
    FROM PERSONA WHERE to_char (fecnacper, 'mm') >=7 ;

--9 Mario Barrios y Brunela Tarazona se han dado de baja en el listado de clientes   
    update persona 
    set estper = 'I'
    where idper = 206 ;
        
        
    update persona 
    set estper = 'I'
    where idper = 205;
        
    select
    UPPER(nomper) as NOMBRE,
    celper as CELULAR,
    emaper as EMAIL,
    estper as ESTADO
    from persona where tipper = 'C';

--10 Listar los CLIENTES cuya edad es mayor de 40
    SELECT 
    (UPPER(APEPER)|| ', ' ||NOMPER) AS "Cliente", 
    emaper  AS "Email", floor(months_between(SYSDATE, FECNACPER) /12) AS "Edad" 
    FROM  PERSONA
    WHERE floor(months_between(SYSDATE, FECNACPER) /12) > '40' AND TIPPER = 'C';
--11 Obtener SUBTOTAL de productos vendidos basado en la tabla VENTA_DETALLE.
    select
    vd.idven,
    pro.NOMPRO as NOMPRO,
    pro.PREPRO as PREPRO,
    vd.CANVENDET as CANVENDET,
    (pro.prepro * vd.canvendet) as SUBTOTAL
    from 
    VENTA_DETALLE vd inner join  PRODUCTO pro on vd.CODPRO = pro.CODPROD;
    
--12 Listar Identificador de la venta, vendedor y subtotal de ventas.
    select
    vd.idven,
    ven.idvend,
    (pro.prepro * vd.canvendet) as SUBTOTAL
    from 
    VENTA_DETALLE vd inner join  PRODUCTO pro on vd.CODPRO = pro.CODPROD
    inner join VENTA ven ON  ven.IDVEN = vd.IDVEN ;
    
--13 Listar monto total de ventas por VENDEDOR.
    /*test 
        inner join VENTA ven ON  ven.IDVEN = vd.IDVEN
        inner join PERSONA pe on pe.IDPER = ven.IDVEND
    */
    select
    pe.idper as ID,
    (pe.apeper ||','||' ' || pe.nomper) as VENDEDOR,
    SUM(pro.prepro * vd.canvendet) as SUBTOTAL
    from 
    VENTA_DETALLE vd inner join  PRODUCTO pro on vd.CODPRO = pro.CODPROD
    inner join VENTA ven ON  ven.IDVEN = vd.IDVEN
    inner join PERSONA pe on pe.IDPER = ven.IDVEND
    GROUP BY pe.idper,(pe.apeper ||','||' ' || pe.nomper);
    
--14 Listar cantidad de productos por CATEGORIA.
    select 
    cat.nomcat as CATEGORIA,
    count(pro.IDCATPRO) as CANTIDAD
    from categoria cat inner join producto pro on pro.IDCATPRO = cat.IDCAT
    GROUP BY cat.nomcat;


--15 Listar la inversión total con que se cuenta en productos por cada categoría.
    SELECT 
    CAT.NOMCAT AS CATEGORIA,
    'S/. ' || SUM(PRO.PREPRO * PRO.STOCKPRO) AS SUBTOTAL
    FROM PRODUCTO PRO INNER JOIN CATEGORIA CAT ON PRO.IDCATPRO=IDCAT GROUP BY CAT.NOMCAT;

--16 Listar los CLIENTES que no han realizado compras.
    select
    (UPPER(pe.apeper) ||','||' ' || pe.nomper) as Cliente,
    pe.celper as CELULAR,
    pe.emaper as EMAIL,
    ven.IDVEN AS IDVEN
    from Persona pe left join VENTA ven on ven.IDCLI = pe.IDPER
    WHERE pe.tipper= 'C' and ven.IDVEN is NULL;

--17 Listar los PRODUCTOS que no figuren en los detalles de venta.
    select
     cat.nomcat as CATEGORIA,
     pro.nompro as PRODUCTO,
     pro.prepro as PRECIO,
     vd.IDVENDET as IDVENTADETALLE
    from Producto pro left join VENTA_DETALLE vd on vd.CODPRO = pro.CODPROD
    inner join CATEGORIA cat ON cat.IDCAT = pro.IDCATPRO
    WHERE vd.IDVENDET is NULL
    ORDER BY cat.nomcat asc;


--18 Insertar los siguientes registros en la tabla PERSONA.
    ALTER TABLE PERSONA MODIFY FECNACPER DATE NULL
    INSERT ALL
    INTO PERSONA (DNIPER,NOMPER,APEPER,EMAPER,CELPER,TIPPER,FECNACPER) VALUES ('85743615','Luis','Vera Hernandéz','luis.vera@empresa.com','996325147','V','')
    INTO PERSONA (DNIPER,NOMPER,APEPER,EMAPER,CELPER,TIPPER,FECNACPER) VALUES ('98453614','Marcos','Ramirez Ojeda','marcos.ramirez@yahoo.com','953485647','C','')
    INTO PERSONA (DNIPER,NOMPER,APEPER,EMAPER,CELPER,TIPPER,FECNACPER) VALUES ('15882637','Andrea','Vasquez Barrantes','andrea.vasquez@outlook.com','963244789','C','')
    INTO PERSONA (DNIPER,NOMPER,APEPER,EMAPER,CELPER,TIPPER,FECNACPER) VALUES ('66332587','Mario','Flores Campos','mario.flores@gmail.com','978754312','C','')
    INTO PERSONA (DNIPER,NOMPER,APEPER,EMAPER,CELPER,TIPPER,FECNACPER) VALUES ('15121487','Bruno','Ochoa Castillo','bruno.ochoa@outlook.com','978754213','C','')
    INTO PERSONA (DNIPER,NOMPER,APEPER,EMAPER,CELPER,TIPPER,FECNACPER) VALUES ('44556137','Celestino','Barrios Solorzano','celestino.barrios@yahoo.com','955654257','C','')
    INTO PERSONA (DNIPER,NOMPER,APEPER,EMAPER,CELPER,TIPPER,FECNACPER) VALUES ('74962584','Amelia','Tapia Conde','amelia.tapia@gmail.com','986644139','C','')
    SELECT * FROM DUAL
    COMMIT;
    select * from Persona where fecnacper is null;
    
--19 Insertar 3 nuevas CATEGORIAS de Productos
    INSERT ALL
    INTO CATEGORIA(NOMCAT) VALUES('Pasteleria')
    INTO CATEGORIA(NOMCAT) VALUES('Cuidado personal')
    INTO CATEGORIA(NOMCAT) VALUES('Frutas y verduras')
    SELECT * FROM DUAL
    COMMIT;
    select NOMCAT from categoria;


--20 Agregar los siguientes productos y listarlos de la siguiente manera:
    INSERT ALL
    INTO PRODUCTO(CODPROD,NOMPRO,PREPRO,STOCKPRO,IDCATPRO) VALUES('P07','Piña Golden',5.49,63,60)
    INTO PRODUCTO(CODPROD,NOMPRO,PREPRO,STOCKPRO,IDCATPRO) VALUES('P08','Palta Hass',7.50,39,60)
    INTO PRODUCTO(CODPROD,NOMPRO,PREPRO,STOCKPRO,IDCATPRO) VALUES('P09','Crema de peinar',5.90,95,50)
    INTO PRODUCTO(CODPROD,NOMPRO,PREPRO,STOCKPRO,IDCATPRO) VALUES('P10','Shampoo Kativa',32.90,72,50)
    INTO PRODUCTO(CODPROD,NOMPRO,PREPRO,STOCKPRO,IDCATPRO) VALUES('P11','Pasta dental triple acción',21.80,91,50)
    INTO PRODUCTO(CODPROD,NOMPRO,PREPRO,STOCKPRO,IDCATPRO) VALUES('P12','Aceite Vegetal',9.75,21,10)
    INTO PRODUCTO(CODPROD,NOMPRO,PREPRO,STOCKPRO,IDCATPRO) VALUES('P13','Pack trozos de atún',26.75,100,10)
    INTO PRODUCTO(CODPROD,NOMPRO,PREPRO,STOCKPRO,IDCATPRO) VALUES('P14','Frijol canario',9.60,72,10)
    SELECT * FROM DUAL
    COMMIT;
    
    select 
    pro.CODPROD as CODPROD,
    pro.nompro as NOMPRO,
    pro.prepro as PREPRO,
    pro.stockpro as STOCKPRO,
    cat.nomcat as NOMCAT,
    pro.estpro as ESTPRO
    from producto pro inner join Categoria cat on cat.IDCAT= pro.IDCATPRO
    ORDER BY CODPROD asc 
--    AND CODPROD >=7
    ;

--21 Listar VENDEDORES que han realizado VENTAS y está ACTIVO en la EMPRESA
    SELECT 
      pe.IDPER,
     (pe.APEPER ||', '|| pe.NOMPER) as VENDEDOR,
     ven.fecven as FECHA,
     vd.IDVENDET AS IDVEN_DETALLE
    FROM PERSONA pe LEFT JOIN VENTA ven on ven.IDVEND = pe.IDPER LEFT JOIN VENTA_DETALLE VD ON ven.IDVEN = VD.IDVENDET
    WHERE TIPPER = 'V' AND ESTPER='A' AND TIPPAGVEN='T' AND FECNACPER IS NOT NULL;
    
--22 Insertar registros tabla VENTA_DETALLE de VENTA (2)
    INSERT ALL
    INTO VENTA_DETALLE(IDVEN,CODPRO,CANVENDET) VALUES(2,'P03',7)
    INTO VENTA_DETALLE(IDVEN,CODPRO,CANVENDET) VALUES(2,'P10',2)
    INTO VENTA_DETALLE(IDVEN,CODPRO,CANVENDET) VALUES(2,'P13',5)
    SELECT * FROM DUAL
    COMMIT;
    
    select 
    vd.idven as IDVEN,
    vd.codpro as CODPRO,
    pro.nompro as NOMPRO,
    vd.canvendet as CANVENDET
    from 
    venta_detalle vd inner join Producto pro on pro.CODPROD= vd.CODPRO
    where IDVEN = 2
    ORDER BY vd.codpro asc;

--23 Insertar registros tabla VENTA_DETALLE de VENTA (3)
    INSERT ALL
    INTO VENTA_DETALLE(IDVEN,CODPRO,CANVENDET) VALUES(3,'P10',6)
    SELECT * FROM DUAL
    COMMIT;
    
    select 
    vd.idven as IDVEN,
    vd.codpro as CODPRO,
    pro.nompro as NOMPRO,
    vd.canvendet as CANVENDET
    from 
    venta_detalle vd inner join Producto pro on pro.CODPROD= vd.CODPRO
    where IDVEN = 3
    ORDER BY vd.codpro asc;

--24 Agregar la fecha de nacimiento a los clientes:
    UPDATE PERSONA SET FECNACPER = '01/03/1990' WHERE IDPER = '228';
    UPDATE PERSONA SET FECNACPER = '10/12/1991' WHERE IDPER = '229';
    UPDATE PERSONA SET FECNACPER = '22/09/1985' WHERE IDPER = '230';
    UPDATE PERSONA SET FECNACPER = '11/07/1980' WHERE IDPER = '231';
    UPDATE PERSONA SET FECNACPER = '17/06/1981' WHERE IDPER = '232';
    UPDATE PERSONA SET FECNACPER = '20/04/1999' WHERE IDPER = '233';
    
    SELECT 
    APEPER ,NOMPER,FECNACPER
    FROM PERSONA WHERE TIPPER = 'C';

--25 Resulta que tenemos un vendedor que le falta la fecha de nacimiento y es la misma fecha de tu nacimiento, por favor agrega el dato faltante. 
    select 
    apeper ,
    nomper,
    fecnacper
    from persona where tipper = 'V' ORDER BY IDPER asc;
    
    
    update persona set fecnacper = '01/07/2002' where idper = '227';
    
    select 
    apeper ,
    nomper,
    fecnacper
    from persona where tipper = 'V' ORDER BY IDPER asc;

--26 Listar los productos de las categoría Abarrotes y Frutas y verduras según se indica: 
    select 
    pro.codprod as Código,
    pro.nompro as Producto,
    ('S/.'||pro.prepro) as PRECIO,
    cat.nomcat as Categoria
    from producto pro inner join categoria cat on cat.IDCAT = pro.IDCATPRO
    where (nomcat = 'Abarrotes') or (nomcat= 'Frutas y verduras')
    ORDER BY cat.nomcat asc ;


--27 La VENTA que estaba realizando EL VENDEDOR ENRIQUEZ FLORES al CLIENTE TARAZONA GUERRA ha sido cancelada.
    update venta set estven = 'I' where idvend = '203' and idcli = '206';
    -----------------------------------------------------------------------------------
    SELECT
    (UPPER(pe.APEPER)||',' ||pe.nomper) as CLIENTE,
    (UPPER(pet.APEPER)||',' ||pet.nomper) as VENDEDOR,
    ven.estven as ESTADOVENTA
    FROM venta ven INNER JOIN persona pe on pe.IDPER = ven.IDCLI
    INNER JOIN persona pet on pet.IDPER = ven.IDVEND
    WHERE ven.estven = 'I';

--28 Agregar una nueva venta de acuerdo a los siguientes datos
INSERT INTO VENTA(IDVEND,IDCLI,TIPPAGVEN) VALUES(207,211,'E');

INSERT ALL
INTO VENTA_DETALLE(IDVEN,CODPRO,CANVENDET) VALUES(5,'P02',7)
INTO VENTA_DETALLE(IDVEN,CODPRO,CANVENDET) VALUES(5,'P09',10)
INTO VENTA_DETALLE(IDVEN,CODPRO,CANVENDET) VALUES(5,'P05',5)
INTO VENTA_DETALLE(IDVEN,CODPRO,CANVENDET) VALUES(5,'P07',6)
INTO VENTA_DETALLE(IDVEN,CODPRO,CANVENDET) VALUES(5,'P03',2)
INTO VENTA_DETALLE(IDVEN,CODPRO,CANVENDET) VALUES(5,'P06',8)
SELECT * FROM DUAL
COMMIT;

SELECT 
PER.APEPER AS VENDEDOR,
PE.APEPER AS CLIENTE,
PRO.NOMPRO AS PRODUCTO,
'S/ '||PRO.PREPRO AS PRECIO,
VD.CANVENDET AS CANTIDAD,
'S/ '||(PRO.PREPRO * VD.CANVENDET) AS SUBTOTAL
FROM VENTA V INNER JOIN PERSONA PER ON V.IDVEND=PER.IDPER 
INNER JOIN VENTA_DETALLE VD ON VD.IDVEN = V.IDVEN 
INNER JOIN PRODUCTO PRO ON VD.CODPRO = PRO.CODPROD
INNER JOIN PERSONA PE ON V.IDCLI=PE.IDPER WHERE V.IDVEN = 5;

--SELECT * FROM VENTA;
--SELECT * FROM VENTA_DETALLE;
--SELECT * FROM PRODUCTO;
--SELECT * FROM PERSONA;

--CLAVE PRINCIPAL