/*Trigger for storing the change in discounts of a product*/
CREATE TABLE discount_log (
  pid     VARCHAR(9),
  New_discount NUMBER,
  Old_discount NUMBER,
  Log_date   DATE  
);


create or replace TRIGGER Log_discount_changes
  AFTER UPDATE OF discount ON product
  FOR EACH ROW
BEGIN
  INSERT INTO discount_log (pid, New_discount, Old_discount, Log_Date)
  VALUES (:new.pid, :new.discount, :old.discount, SYSDATE);
END;
/* stock change log*/
/*This trigger updates the value of  stock of items*/
CREATE TABLE stock_log (
  stockid     VARCHAR(9),
  New_stock NUMBER,
  Old_stock NUMBER,
  Log_date   DATE  
);


create or replace TRIGGER Log_stock_changes
  AFTER UPDATE OF quantity ON stock
  FOR EACH ROW
BEGIN
  INSERT INTO stock_log 
  VALUES (:new.stockid, :new.quantity, :old.quantity, SYSDATE);
END;

/*stored procedures */
/*set discount as 50 when discount>50*/



create or replace PROCEDURE Decrease_discount AS 

thisProduct Product%ROWTYPE;

CURSOR discount_50 IS
SELECT * FROM product where discount>50 FOR UPDATE;

BEGIN
OPEN discount_50;
LOOP
  FETCH discount_50 INTO thisProduct;
  EXIT WHEN (discount_50%NOTFOUND);
  dbms_output.put_line(thisProduct.pid);
  dbms_output.put_line(thisProduct.discount);
  UPDATE product SET discount = 50
  WHERE CURRENT OF discount_50;

END LOOP;
CLOSE discount_50;
END;


/* Procedure that will change the price of a particular product sold by a particular seller*/

create or replace PROCEDURE Change_Price(pid IN sells.pid%TYPE, sid IN sells.sid%type,newprice int) AS 

thisSells sells%ROWTYPE;

CURSOR sells_c IS
SELECT * FROM sells;

BEGIN
OPEN sells_c;
LOOP
  FETCH sells_c INTO thisSells;
  EXIT WHEN (sells_c%NOTFOUND);

update sells set price=newprice where sid=sid and pid=pid;
dbms_output.put_line( ' Price has been updated');

END LOOP;
CLOSE sells_c;
END;

