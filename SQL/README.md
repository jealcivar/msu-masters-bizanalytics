drop table workon; 
drop table employee; 
drop table project; 
drop table division; 

create table division 
(did integer, 
dname varchar (25), 
managerID integer, 
constraint division_did_pk primary key (did) 
); 

create table employee 
(empID integer, 
name varchar(30), 
salary float, 
did integer, 
constraint employee_empid_pk primary key (empid), 
constraint employee_did_fk foreign key (did) references division(did) 
); 

create table project 
(pid integer, 
pname varchar(25), 
budget float, 
did integer, 
constraint project_pid_pk primary key (pid), 
constraint project_did_fk foreign key (did) references division(did) 
); 

create table workon 
(pid integer, 
empID integer, 
hours integer, 
constraint workon_pk primary key (pid, empID),
constraint workon_pid_fk foreign key (pid) references project(pid), 
constraint workon_empid_fk foreign key (empID) references employee(empID) 
); 

/* loading the data into the database */ 

insert into division 
values (1,'engineering', 2); 
insert into division 
values (2,'marketing', 1); 
insert into division 
values (3,'human resource', 3); 
insert into division 
values (4,'Research and development', 5); 
insert into division 
values (5,'accounting', 4); 

insert into project 
values (1, 'DB development', 8000, 2); 
insert into project 
values (2, 'network development', 6000, 2); 
insert into project 
values (3, 'Web development', 5000, 3); 
insert into project 
values (4, 'Wireless development', 5000, 1); 
insert into project 
values (5, 'security system', 6000, 4); 
insert into project 
values (6, 'system development', 7000, 1); 

insert into employee 
values (1,'kevin', 32000,2); 
insert into employee 
values (2,'joan', 42000,1); 
insert into employee 
values (3,'brian', 37000,3); 
insert into employee 
values (4,'larry', 82000,5); 
insert into employee 
values (5,'harry', 92000,4); 
insert into employee 
values (6,'peter', 45000,2); 
insert into employee 
values (7,'peter', 68000,3); 
insert into employee 
values (8,'smith', 39000,4); 
insert into employee 
values (9,'chen', 71000,1); 
insert into employee 
values (10,'kim', 46000,5); 
insert into employee 
values (11,'smith', 46000,1); 
insert into employee 
values (12,'joan', 48000,1); 
insert into employee 
values (13,'kim', 49000,2); 
insert into employee 
values (14,'austin', 46000,1); 
insert into employee 
values (15,'sam', 52000,5);
insert into employee 
values (16,'Justin', 62000,2); 
insert into employee 
values (17,'Nacy', 52000,1);
insert into employee 
values (18,'Marilyn', 52000,5);
insert into employee 
values (19,'Kristie', 52000,1);
insert into employee 
values (20,'John', 52000,3);
insert into employee
values (21,'Alex', 69000,1); 
insert into employee 
values (22,'Phil', 72000,2);
insert into employee 
values (23,'Steve', 74000,4);
insert into employee 
values (24,'Jenna', 69000,1);
insert into employee 
values (25,'Alan', 62000,2);
insert into employee
values (26,'Julia', 69000,4); 
insert into employee 
values (27,'Sandra', 72000,4);
insert into employee 
values (28,'Joe', 74000,4);
insert into employee 
values (29,'karl', 69000,5);
insert into employee 
values (30,'grace', 62000,4);


insert into workon 
values (3,1,30); 
insert into workon 
values (2,3,40); 
insert into workon 
values (5,4,30); 
insert into workon 
values (6,6,60); 
insert into workon 
values (4,3,70); 
insert into workon 
values (2,4,45); 
insert into workon 
values (5,3,90); 
insert into workon 
values (3,3,100); 
insert into workon 
values (6,8,30); 
insert into workon 
values (4,4,30); 
insert into workon 
values (5,8,30); 
insert into workon 
values (6,7,30); 
insert into workon 
values (6,9,40); 
insert into workon 
values (5,9,50); 
insert into workon 
values (4,6,45); 
insert into workon 
values (2,7,30); 
insert into workon 
values (1,8,30); 
insert into workon 
values (2,9,30); 
insert into workon 
values (1,9,30); 
insert into workon 
values (2,8,30); 
insert into workon 
values (1,7,30); 
insert into workon 
values (1,5,30); 
insert into workon 
values (1,6,30); 
insert into workon 
values (2,6,30);
insert into workon 
values (2,12,30);
insert into workon 
values (3,13,30);
insert into workon 
values (4,14,20);
insert into workon 
values (4,15,40);
insert into workon 
values (2,19,30); 
insert into workon 
values (1,19,30); 
insert into workon 
values (5,18,30); 
insert into workon 
values (3,17,30); 
insert into workon 
values (4,25,30); 
insert into workon 
values (3,16,30); 
insert into workon 
values (2,16,30);
insert into workon 
values (2,22,30);
insert into workon 
values (3,23,30);
insert into workon 
values (4,24,20);
insert into workon 
values (6,25,40);
insert into workon 
values (3,21,40);

insert into workon 
values (4,26,20);
insert into workon 
values (4,27,40);
insert into workon 
values (2,27,30); 
insert into workon 
values (1,26,30); 
insert into workon 
values (5,26,30); 
insert into workon 
values (3,26,30); 
insert into workon 
values (4,28,30); 
insert into workon 
values (3,28,30); 
insert into workon 
values (2,29,30);
insert into workon 
values (2,30,30);
insert into workon 
values (3,30,30);
insert into workon 
values (4,21,20);
insert into workon 
values (6,22,40);
insert into workon 
values (1,30,40);

