import java.sql.*;
import java.util.Scanner;

public class Main {

    Connection conn = null;

    public static void main(String[] args) throws Exception {
        Main unv = new Main();
        unv.run();

    }

    /**
     * Create connection here
     *
     * @throws Exception
     */
    public Main() throws Exception {
        System.out.println("Library Management Software v0.1");


    }
    
    private int checkAdmin()
    {
    	System.out.println("\nAre you user or admin?");
        System.out.println("1- Admin");
        System.out.println("2- User");
        System.out.println("0- Exit");
        Scanner input = new Scanner(System.in);
        int choice = input.nextInt();   
        if (choice == 1)
        {
        	return 1;
        }
        else if (choice == 2)
        {
        	return 2;
        }
        else if (choice == 0)
        {
        	return 0;
        }
        else
        {
        	System.out.println("\nError! Try Again !");
        	return checkAdmin();
        }
    }

    private void run() throws Exception {
        this.conn = null;
        try {
            conn = getConnection();
            System.out.println("Connected to the database");
            int check = checkAdmin();
            if (check == 1)
            { // Admin
            int choice = 0;
            Scanner input = new Scanner(System.in);
            do {
                System.out.println("\nEnter choice, 0 to exit");
                System.out.println("1- Add Book");
                System.out.println("2- Search Book");
                System.out.println("3- Statistics : Number of books taken and not returned");
                System.out.println("0- Exit");
                choice = input.nextInt();

                switch (choice) {
                    case 1:
                        System.out.println("Enter student No");
                        String stId = input.next();
                        findStudent(stId);
                        break;
                    case 2:
                        System.out.println("Enter faculty");
                        String facl = input.next();
                        listCourses(facl);
                        break;
                    case 3:
                    	break;
                    case 0:
                        System.out.println("bye");
                        break;
                    default:
                        System.out.println("Must be one of 1,2,3");
                }

            } while (choice != 0);
            
            } // User 
            else if (check == 2)
            {
            	int choice = 0;
                Scanner input = new Scanner(System.in);
                do {
                    System.out.println("\nEnter choice, 0 to exit");
                    System.out.println("1- Borrow Book (at most 5)");
                    System.out.println("2- Search Book");
                    System.out.println("3- Return Book");
                    System.out.println("0- Exit");
                    choice = input.nextInt();

                    switch (choice) {
                        case 1:
                            System.out.println("Enter student No");
                            String stId = input.next();
                            findStudent(stId);
                            break;
                        case 2:
                            System.out.println("Enter faculty");
                            String facl = input.next();
                            listCourses(facl);
                            break;
                        case 3:
                        	break;
                        case 0:
                            System.out.println("bye");
                            break;
                        default:
                            System.out.println("Must be one of 1,2,3");
                    }

                } while (choice != 0);
            }
        } finally {
            if (conn != null) {
                conn.close();
                System.out.println("Disconnected from database");
            }
        }
    }

    private void findStudent(String stuNo) throws SQLException {
        PreparedStatement ps = null;
        ResultSet result = null;
        try {
            ps = this.conn.prepareStatement(
                    "SELECT studentNo, stuFirstname, stuLastname, stuGpa"
                    + " FROM  student WHERE studentNo = ?");
            ps.setString(1, stuNo);
            result = ps.executeQuery();
            if (result.next()) {
                String fName = result.getString("StuFirstname"); //result.getString(2); 
                String lName = result.getString("StuLastname"); //  result.getString(3); 
                double gpa = result.getDouble("StuGpa"); //  result.getString(3); 
                System.out.println("Student with ID : " + stuNo + " found");
                System.out.println("Firstname : " + fName + ", lastname : " + lName + ",gpa : " + gpa);
            } else {
                System.out.println("Student with ID : " + stuNo + " NOT found");
            }
        } finally {
            if (ps != null) {
                ps.close();
            }
            if (result != null) {
                result.close();
            }
        }
    }

    /**
     * EX
     *
     * @param facName
     * @throws SQLException
     */
    private void listCourses(String facName) throws SQLException {
        PreparedStatement ps = null;
        ResultSet result = null;
        try {
            ps = this.conn.prepareStatement(
                    "SELECT crsCode, crsDesc " +
                    " FROM course INNER JOIN department on course.deptName = department.deptName " +
                    " WHERE facName = ?");
            ps.setString(1, facName);
            result = ps.executeQuery();
            System.out.println("crsCode\tcrsDesc") ;
            boolean fnd = false;
            while (result.next()) {
                fnd = true;
                String crsCode = result.getString("crsCode"); //result.getString(2); 
                String crsDesc = result.getString("crsDesc"); //  result.getString(3); 
                System.out.println(crsCode + "\t" + crsDesc);
            }
            if(!fnd) {
                System.out.println("(NO RECORDS FOUND)");
            }
        } finally {
            if (ps != null) {
                ps.close();
            }
            if (result != null) {
                result.close();
            }
        }

    }

    private void updateStudentGpa(String stuNo, double gpa) throws SQLException {
        PreparedStatement ps = null;

        try {
            ps = this.conn.prepareStatement(
                    "UPDATE student SET stuGpa = ? WHERE studentNO = ?");

            ps.setDouble(1, gpa);
            ps.setString(2, stuNo);
            int affected = ps.executeUpdate();
            if (affected == 1) {
                System.out.println("updated successfully");
            } else {
                System.out.println("update not successful. Possible: Student not found");
            }
        } finally {
            if (ps != null) {
                ps.close();
            }
        }
    }

    private static Connection getConnection() throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException {
        Connection conn = null;
        String url = "jdbc:sqlserver://localhost;database=labwork";
        String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String userName = "sa";
        String password = "hello1234";
        Class.forName(driver).newInstance();
        conn = DriverManager.getConnection(url, userName, password);
        System.out.println("Connected to the database");
        return conn;
    }
}
