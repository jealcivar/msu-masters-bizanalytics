/*Part A
Read Chapter 2,7,8 and study the use of the statements of CREATE, UPDATE, INSERT AND ALTER and do the 
following tasks (copy each task and show the SQL code and the results (table contents) for each task. 
Also refer to statements in loadDB.sql   download   file to learn how the create/insert statements are 
formulated, including the naming convention.*/

/*a1.  Use CREATE  statement to create a table Client (AcctNo, ClientName,  phone). Note AcctNo is primary 
key and you must definea constraint for this primary key in CREATE statement. Use Char for the data type of 
phone. Show the statement.*/

create table Client
(AcctNo integer,
ClientName varchar (35),
phone char (10),
constraint client_AcctNo_pk primary key (AcctNo)
);

/*a2. Use INSERT statement to add two client records (insert two client with different account number, make up your 
own data for clients). Show the INSERT statements and use select statement to show the table contents.*/

insert into client
values (1, 'Chase', '12345');
insert into client
values (2, 'Apple', '56789');

 
/*a3.  Use ALTER statements to add a foreign key ClientAcct, into the Project table, which has values of the AcctNo of 
Client . So that table Client has a 1:M relationship with table Project. Note, you need to use TWO ALTER statements, one 
for adding ClientAcct into Project table; one for adding foreign key constraint named as project_ClientAcct_fk into Project 
table. Show the ALTER statements.*/

alter table project add ClientAcct integer
alter table project add constraint project_ClientAcct_fk foreign key (ClientAcct) references client(acctno)

/*a4 use update statement to assign account number to the project(s) with the name that word 'system' . Write another statement 
to assign another account number to the rest of the projects.*/

update project
set clientacct = 2
where lower(pname) LIKE '%system%'

 
update project
set clientacct = 1
where lower(pname) NOT LIKE '%system%'
 
/*a5. Test the the foriegn key constraint by inserting a new project with wrong client account number. Show the result.*/
  
insert into project
values (7, 'x', 5000, 4, 3)

 
/*a6. User ALTER statement to Add an attribute Project_Count into Employee table (data type to be integer, refer to the data 
type used for Workon table (hours)  in loadDB file).*/

alter table employee add ProjectCount integer

/*a7. Use UPDATE statement to fill the value of Project_count of each employee record in Employee table. Namely, add the count 
of total number of projects an employee works on into Project_count in Employee table for each employee.  Hint: you need a 
subquery in Update statement as follows
  Update _________
  Set _____ = (select count (pid) ...... )
Show the contents of Employee after update.*/

update employee e
set projectcount = (select count(pid) 
                     from workon w
                     where w.empid = e.empid) 
 
/*a8. Create a table Promotion_list (EMPID, Name, Salary, DivisionName).*/

create table Promotion_list
(EMPID integer,
Name varchar (20),
Salary float,
DivisionName varchar (25),
constraint promotion_list_EMPID_pk primary key (EMPID)
);

/*a9. Load Promotion_list with the information of employees who make less than company average 
and work on at least 2 projects. (Hint use INSERT INTO SELECT statement ). Show the code and result.*/

insert into Promotion_list
select e.empid, name, salary, dname
from division d
join employee e
on d.did = e.did
join workon w
on e.empid = w.empid
where salary < (select avg(salary) from employee)
group by e.empid, name, salary, dname
having count(pid) >= 2
order by empid
 
/*Part B
b1. Increase the budget of a project by 5% if there is a manager working on it .*/

update project
set budget = budget * 1.05
where pid in (select distinct p.pid
              from division d
              join employee e
              on e.empid = d.managerid
              join workon w
              on w.empid = e.empid
              join project p
              on w.pid = p.pid)
 
/*b2. List the name of employee who does not work on a project sponsored by his/her own division. (correlated subquery with NOT EXISTS)*/

select distinct e.empid, name
from employee e
where NOT EXISTS (select *
                from project p
                join workon w
                on w.pid = p.pid
                where e.did = p.did
                and e.empid = w.empid)
order by empid
 
/*b3. List the name of project that has budget that is higher than ALL projects from 'marketing' division.*/
 
select pname, budget
from project p
where budget >ALL (select budget 
                   from project p 
                   join division d 
                   on p.did = d.did 
                   where lower(dname) = 'marketing')
 
/*b4. For each diision, list its name and its divisional total salary and its total project the division has (Show three 
colums in result. Hint; use correlated subquery in top SELECT clause. Note, this query cannot be done by simply join three 
tables as follows,  can you tell me why (a bonus point) ?)*/

select dname, sum(salary), count(pid)
from division d, employee e, project p
where d.did = e.did and d.did = p.did
group by dname
select dname, (select sum(salary) 
               from employee e 
               where e.did = d.did) DivisionTotalSalary, (select count(pid) 
                                                          from project p 
                                                          where p.did = d.did) DivisionTotalProjectCount
from division d
/*-	You cannot join the three tables to get the correct answer because the joining would repeat all the salaries in the project 
count and will duplicate the project counts also. Additionally, the join would not show EACH division, it will only output the 
divisions that have a project. If you join more than two tables together along with some calculated function (count), (sum), your 
results may be duplicated.*/
 
/*b5. List the name of employee who work on more projects than employee 'Grace'', Show three columns in result: name of employee, 
project count of employee, grace's project count. */
 
select e.empid, name, count(pid) ProjectCount, (select count(pid)
                                                from workon w
                                                join employee e
                                                on e.empid = w.empid
                                                where lower(name) = 'grace') GraceProjectCount
from employee e
join workon w
on w.empid = e.empid
having count(pid) > (select count(pid)
                    from workon w
                    join employee e
                    on e.empid = w.empid
                    where lower(name) = 'grace')
group by e.empid, name
order by empid
 
/*b6. List The name of division that has employee(s) who work on other division's project .  (correlated subquery)*/

select distinct d.did, dname
from division d
join employee e
on e.did = d.did
join workon w
on w.empid = e.empid
where pid in (select pid 
              from project p 
              where d.did != p.did)
order by d.did
 
/*b7. List the name of employee who works ONLY with his/her divisional colleagues on project(s).  (Hint, namely, the 
employee (e) firstly works on project(s) , and secondly, there NOT EXISTS a project that  (e)  works on and another 
employee (ee) also works on but they are from different divisions.) */

select e.empid, name
from employee e
join workon w
on e.empid = w.empid 
and NOT EXISTS (select * 
                from employee ee 
                join workon ww 
                on ww.empid = ee.empid 
                where ww.pid = w.pid 
                and ee.did != e.did)
 
