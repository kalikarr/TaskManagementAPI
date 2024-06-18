# TaskManagementSystem
# Please follow the following instructions to setup and run the project
- Please chekout the code
- There are two project TaskManagementAPI and TaskManagementUI that I have added to same repo for your convenitant
- Open the 2 Projects in 2 separate solutions using visual studio 2022
- Build the both the Projects
- Go to TaskManagementSystem\Database folder 
   - Run the Database.sql in SSMS 
   - Then Run the DatabaseData.sql
- Update the connection strings in Web.config in the API project
- RUN the projects in (IISExpress with SSL)
   - First run the API project
   - Then RUN the UI project (if any change to the API URL(https://localhost:44397/) please make sure to update ApiBaseUrl appsetting key in UI project accordinly)
- You wll ask to enter the login details,
  - I have setup 4 users
  - Password is password123  and its same  for all the 4 users
  - Login User names are john_doe, jane_smith, alice_jones, bob_brown
  
* Makesure that the API project should be in running mode to work the UI project

 1- Login Page
![image](https://github.com/kalikarr/TaskManagementSystem/assets/14090388/278696bb-17f7-4aa6-b0cb-421a0ef8306b)

 2- Task Management Page
![image](https://github.com/kalikarr/TaskManagementSystem/assets/14090388/ee802f75-1aff-49cf-bb90-f03e182fa396)

