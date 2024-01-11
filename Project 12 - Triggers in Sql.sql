/*
Triggers - A trigger is a special kind of stored procedure that automatically executes when an event occurs in 
           the database server.
Types    - DML Trigger, DDL Trigger, Logon Trigger
DML Triggers Types - After Triggers, Instead of Triggers
*/

--DML Triggers
drop table tbl_student;
create table tbl_student
             (Id int identity, Name varchar(50), Gender varchar(10), Class int, fees bigint);

insert into tbl_student
values      ('Osama', 'Male', 10, 4000),
            ('Anum', 'Female', 9, 3500),
			('Taha', 'Male', 8, 3000),
			('Maheen', 'Female', 10, 4000),
			('Abdul', 'Male', 9, 3500),
			('Mushtaq', 'Male', 5, 3000);

select * from tbl_student;

--After Insert Trigger

create trigger tr_Student_forinsert
on tbl_student
after insert
as
begin
   print 'Something happened to the student table';
end

--now inserting a new row in tbl_student and you can see a trigger gets fired automatically
insert into tbl_student values ('Anas', 'Male', 7, 3000);

--now i want to make some changes in my trigger by using alter command
alter trigger tr_Student_forinsert
on tbl_student
after insert
as
begin
   select * from inserted
end
--if i want to add another student
insert into tbl_student values ('Muneer', 'Male', 8, 4000);

--Delete Trigger
create trigger tr_Student_forDelete
on tbl_student
after delete
as
begin
   select * from deleted
end

--when i delete this row the trigger gets fired automatically and keeps its copy in a separate table
delete from tbl_student where id = 8;

--now i'm inserting these three rows in tbl_student
--trigger gets executed three times automatically

insert into tbl_student values ('Muneer', 'Male', 8, 4000);
insert into tbl_student values ('Momina', 'Female', 9, 4000);
insert into tbl_student values ('Aslam', 'Male', 7, 4000);

--and if i delete multiple rows then similarly the triggers gets executed thrice
delete from tbl_student where id = 9;
delete from tbl_student where id = 10;
delete from tbl_student where id = 11;

--another way of doing it that anything added or deleted in tbl_student i want to store it in a separate table called audit information
--anything deleted or added in tbl_student it stores the information in audit table
create table tbl_student_audit
             (Audit_Id int primary key identity, Audit_Info varchar(max));

select * from tbl_student_audit;

--now i want that any row inserted into this tbl_student the information stored in audit table
create trigger tr_audit_forinsert 
on tbl_student
after insert
as
begin
    Declare @id int
	Select @id = id from inserted

	insert into tbl_student_audit
	values('Student with id ' + cast(@id as varchar(50)) + ' is added at ' + cast(getdate() as varchar(50))); 
end

--the trigger that first gets fired automaticcally is an insert trigger after inserting a row in tbl_student
insert into tbl_student values('Mumtaz', 'Female', 6, 3000);

--the second trigger sends information to the audit table after executing it
select * from tbl_student_audit;
--inserting another row
insert into tbl_student values('Aslam', 'Male', 7, 4000);

select * from tbl_student_audit;

--creating another trigger for delete
create trigger tr_audit_fordelete
on tbl_student
after delete
as
begin
    Declare @id int
	Select @id = id from deleted

	insert into tbl_student_audit
	values('Existing student with id ' + cast(@id as varchar(50)) + ' is deleted at ' + cast(getdate() as varchar(50))); 
end
--now i wanted to delete a row the deleted trigger gets fired and it sends a message in audit table
delete from tbl_student where id = 13;

select * from tbl_student_audit;

--in creating update trigger one row gets deleted and one row gets inserted 
create trigger tr_Student_forUpdate
on tbl_student
after update
as
begin
   select * from inserted
   select * from deleted
end

update tbl_student set Name = 'Ali', Gender = 'Male'
where id = 12;
---------------------------------------------------------------------------------------------------------------------
--DML Instead of Triggers
--Instead of Insert Trigger
--Instead of Update Trigger
--Instead of Delete Trigger

drop table tbl_customer;
create table tbl_customer
            (Id int primary key, Name varchar(50), Gender varchar(10), City varchar(50), ContactNo varchar(200));

insert into tbl_customer 
values     (1, 'Ali', 'Male', 'Hyderabad', '03335465678'),
           (2, 'Anam', 'Female', 'Karachi', '03225465678'),
		   (3, 'Osama', 'Male', 'Sukkur', '03135468778'),
		   (4, 'Amna', 'Female', 'Hyderabad', '03005465678'),
		   (5, 'Affan', 'Male', 'Karachi', '03135465678'),
		   (6, 'Anas', 'Male', 'Hyderabad', '03135468774');

--whenever someone tries to insert any row in tbl customer then fired this trigger before inserting this row
create trigger tr_cust_Insteadof_Insert
on tbl_customer
instead of insert 
as
begin
   print 'You are not allowed to insert data in this table !'
end

--inserting a row
insert into tbl_customer 
values     (7, 'Usman', 'Male', 'Karachi', '03335468774');

--now if you're executing this table you can see the 7 row never gets inserted because of this instead of trigger
select * from tbl_customer;

--now i'm again inserting this row in tbl_customer again the row gets inserted in inserted trigger
insert into tbl_customer 
values     (7, 'Usman', 'Male', 'Karachi', '03335468774');

--Instead of Update Trigger
--the same thing happened with update it only fired the trigger tr_cust_Insteadof_Update
--but never let anyone to update any data in mentioned table
create trigger tr_cust_Insteadof_Update
on tbl_customer
instead of update 
as
begin
   print 'You are not allowed to update data in this table !'
end

update tbl_customer set Name = 'Asif' where id = 6;

select * from tbl_customer;

--Instead of Delete Trigger
create trigger tr_cust_Insteadof_Delete
on tbl_customer
instead of delete
as
begin
   print 'You are not allowed to delete data in this table !'
end

delete from tbl_customer where id = 6;

create table customer_audit_table
            (Audit_Id int primary key identity, Audit_Information varchar(max));

select * from customer_audit_table;

--You can only place Insead of DML triggers on one table you need to drop the previous instead of trigger applying on tbl_customer
drop trigger tr_cust_Insteadof_Insert;
create trigger tr_cust_Insteadof_Insert_Audit
on tbl_customer
instead of insert
as
begin
   insert into customer_audit_table 
   values('Someone tries to insert data in customer table at: ' + cast(getdate() as varchar(50)));
end

insert into tbl_customer 
values     (7, 'Usman', 'Male', 'Karachi', '03335468774');

select * from tbl_customer;
select * from customer_audit_table;

drop trigger tr_cust_Insteadof_Update;
create trigger tr_cust_Insteadof_Update_Audit
on tbl_customer
instead of update
as
begin
   insert into customer_audit_table 
   values('Someone tries to update data in customer table at: ' + cast(getdate() as varchar(50)));
end

update tbl_customer set Name = 'Asif' where id = 6;

select * from tbl_customer;
select * from customer_audit_table;

drop trigger tr_cust_Insteadof_Delete;

create trigger tr_cust_Insteadof_Delete_Audit
on tbl_customer
instead of delete
as
begin
   insert into customer_audit_table 
   values('Someone tries to delete data in customer table at: ' + cast(getdate() as varchar(50)));
end

delete from tbl_customer where id = 6;

--A DML trigger can be encrypted to hide its definition or query by using WITH ENCRYPTION command.
--Means with encryption command allows no one to see your query
alter trigger tr_cust_Insteadof_Delete_Audit
on tbl_customer
with encryption
instead of delete
as
begin
   insert into customer_audit_table 
   values('Someone tries to delete data in customer table at: ' + cast(getdate() as varchar(50)));
end

---------------------------------------------------------------------------------------------------------