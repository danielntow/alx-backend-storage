-- create a trigger to decrease quantity number after an insert
delimiter |
CREATE TRIGGER decreaseQuan AFTER INSERT
ON orders
FOR EACH ROW
BEGIN
UPDATE items
SET items.quantity = items.quantity - NEW.number
WHERE items.name = NEW.item_name;
END;
|
delimiter ;
