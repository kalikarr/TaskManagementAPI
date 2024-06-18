# TaskManagementSystem
# Please follow the following instructions to setup and run the project
- Please chekout the code  git clone https://github.com/kalikarr/TaskManagementSystem.git
- There are two project solutions TaskManagementAPI and TaskManagementUI, that I have added to same repo for your convenitant
- Open the two projects in separate solutions using Visual Studio 2022.
- Build both TaskManagementAPI and TaskManagementUI projects.
- Navigate to the TaskManagementSystem/Database folder.
   - Run Database.sql in SQL Server Management Studio (SSMS). 
   - Then run DatabaseData.sql.
- Update the connection strings in the Web.config file in the API project.
- Run the projects in IIS Express with SSL
   - First, run the API project.
   - Then, run the UI project.
   - If there are any changes to the API URL (e.g., https://localhost:44397/), ensure to update the ApiBaseUrl appsetting key in the UI project accordingly.
- You will be prompted to enter login details
  - Four users are set up
     - Login user names are john_doe, jane_smith, alice_jones, bob_brown
     - Password is password123  (same for all users)
  
* Important Note
   - Ensure the API project is running for the UI project to work correctly.
   - You can export the chart by clicking on the hamburger icon located at the top right corner of the chart area.


#If you encounter any issues, please  contact me.

 1- Login Page
![image](https://github.com/kalikarr/TaskManagementSystem/assets/14090388/278696bb-17f7-4aa6-b0cb-421a0ef8306b)

 2- Task Management Page
![image](https://github.com/kalikarr/TaskManagementSystem/assets/14090388/ee802f75-1aff-49cf-bb90-f03e182fa396)

