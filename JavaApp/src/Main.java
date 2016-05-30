import java.sql.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Scanner;
import java.util.Date;

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
                        System.out.println("Enter Book Name");
                        String bookName = input.next();
                        System.out.println("Enter Author Name");
                        String authorName = input.next();
                        System.out.println("Enter Category Name");
                        String categoryName = input.next();
                        System.out.println("Enter Publisher Name");
                        String publisherName = input.next();
                        System.out.println("Enter Page Numbers");
                        String page = input.next();
                        System.out.println("Enter ISBN (9 characters)");
                        String ISBN = input.next();
                        System.out.println("Publish Date (e.g. 2015-11-20)");
                        String publishDate = input.next();
                        addBook(bookName, authorName,categoryName,publisherName,Integer.parseInt(page),Integer.parseInt(ISBN),publishDate);
                        break;
                    case 2:
                    	
                    	System.out.println("\nEnter choice, 0 to back to upper menu");
                        System.out.println("1- Search By ISBN");
                        System.out.println("2- Search By Title");
                        int choice2 = input.nextInt();
                        switch (choice2) {
                        case 1:
                        	System.out.println("\nEnter 9 digit ISBN Number");
                        	searchByISBN(input.nextInt());
                        	break;
                        case 2:
                        	System.out.println("\nEnter Book Name");
                        	searchByString(input.next());
                            break;
                        default :
                        	break;
                        }
                        break;
                    case 3:
                    	statistics();
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
                            System.out.println("Enter Book Id");
                            int bookId = input.nextInt();
                            System.out.println("When will you return the book (e.g. 2015-11-20)");
                            String endDate = input.next();
                            borrowBook(stId,bookId,endDate);
                            break;
                        case 2:
                        	System.out.println("\nEnter choice, 0 to back to upper menu");
                            System.out.println("1- Search By ISBN");
                            System.out.println("2- Search By Title");
                            int choice2 = input.nextInt();
                            switch (choice2) {
                            case 1:
                            	System.out.println("\nEnter 9 digit ISBN Number");
                            	searchByISBN(input.nextInt());
                            	break;
                            case 2:
                            	System.out.println("\nEnter Book Name");
                            	searchByString(input.next());
                                break;
                            default :
                            	break;
                            }
                            break;
                        case 3:
                        	 System.out.println("Enter student No");
                             String stId2 = input.next();
                             System.out.println("Enter Book Id");
                             int bookId2 = input.nextInt();
                             returnBook(stId2,bookId2);
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

    private void returnBook(String stId, int bookId) throws SQLException {
    	PreparedStatement ps = null;

       try {
       	 
           ps = this.conn.prepareStatement(
                   "UPDATE state set stateType = 0 FROM state JOIN stateDetail on stateDetail.bookId = ? WHERE state.studentNumber = ?");
           ps.setInt(1, bookId);
           ps.setString(2, stId);
           int affected = ps.executeUpdate();
           if (affected == 1) {
               System.out.println("returned book");
           } else {
               System.out.println("returning book unsuccessful");
           }
       } finally {
           if (ps != null) {
               ps.close();
           }
       }
		
	}
    private void borrowBook(String stId, int bookId, String endDate)throws SQLException {
    	PreparedStatement ps = null;

       try {
       	 
           ps = this.conn.prepareStatement(
                   "INSERT INTO state (stateType,startDate,endDate,studentNumber) VALUES (?,?,?,?); INSERT INTO stateDetail (bookId) VALUES (?);");
           DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
           Date date = new Date();
           ps.setInt(1, 1);
           ps.setString(2, dateFormat.format(date));
           ps.setString(3, endDate);
           ps.setString(4, stId);
           ps.setInt(5, bookId);
           int affected = ps.executeUpdate();
           if (affected == 1) {
               System.out.println("borrowed book");
           } else {
               System.out.println("borrowing book unsuccessful : possible reason, there isn't any book left");
           }
       } finally {
           if (ps != null) {
               ps.close();
           }
       }
		
	}

	private void searchByString(String next) throws SQLException {
    PreparedStatement ps = null;
   	 ResultSet result = null;

       try {
       	
       	ps = this.conn.prepareStatement("SELECT * FROM Book "
       			+ "JOIN author on author.authorId = Book.authorId "
       			+ "JOIN publisher on publisher.publisherId = Book.publisherId "
       			+ "JOIN category on category.categoryId = Book.categoryId "
       			+ "WHERE bookName LIKE ?");
       	ps.setString(1,"%"+ next + "%");
       	result = ps.executeQuery();	
       			
       	 while (result.next()) {
	                System.out.println(result.getInt("bookId")+ " | " 
	                				+ result.getString("bookName")+ " | " 
	                				+ result.getString("categoryName")+ " | "
	                				+ result.getInt("page")+ " | "
	                				+ result.getString("authorName")+ " | "
	                				+ result.getString("publisherName"));
	            }
       	 ps.close();
       	
       } finally {
           if (ps != null) {
               ps.close();
           }
       }
		
	}
		
	

	private void searchByISBN(int nextInt) throws SQLException {
	    PreparedStatement ps = null;
	   	 ResultSet result = null;

	       try {
	       	
	       	ps = this.conn.prepareStatement("SELECT * FROM Book "
	       			+ "JOIN author on author.authorId = Book.authorId "
	       			+ "JOIN publisher on publisher.publisherId = Book.publisherId "
	       			+ "JOIN category on category.categoryId = Book.categoryId "
	       			+ "WHERE ISBN = ?");
	       	ps.setInt(1,nextInt);
	       	result = ps.executeQuery();	
	       			
	       	 while (result.next()) {
		                System.out.println(result.getString("bookName")+ " | " 
		                				+ result.getString("categoryName")+ " | "
		                				+ result.getInt("page")+ " | "
		                				+ result.getString("authorName")+ " | "
		                				+ result.getString("publisherName"));
		            }
	       	 ps.close();
	       	
	       } finally {
	           if (ps != null) {
	               ps.close();
	           }
	       }
			
		}

	private void statistics() throws SQLException {
        	PreparedStatement ps = null;
        	 ResultSet result = null;

            try {
            	
            	ps = this.conn.prepareStatement("SELECT * FROM showCurrentBookOwnershipStatus WHERE Status = 'Borrowed'");
            	result = ps.executeQuery();	
            			
            	 while (result.next()) {
    	                System.out.println(result.getString("bookName")+ " | " 
    	                				+ result.getString("authorName")+ " | "
    	                				+ result.getInt("page")+ " | " 
    	                				+ result.getString("studentName")+ " | "
    	                				+ result.getDate("startDate")+ " | " 
    	                				+ result.getDate("endDate"));
    	            }
            	 ps.close();
            	
            } finally {
                if (ps != null) {
                    ps.close();
                }
            }
    		
    	}

	private void addBook(String bookName, String authorName, String categoryName, String publisherName, int page,
			int ISBN, String publishDate) throws SQLException {
    	PreparedStatement ps = null;
    	 ResultSet result = null;
    	 Boolean isInserted =false;
    	 int authorId = 0;
    	 int categoryId = 0;
    	 int publisherId = 0;

        try {
        	 
        	ps = this.conn.prepareStatement("INSERT INTO author (authorName) VALUES (?);");
        	ps.setString(1, authorName);
        	isInserted = ps.execute();	
        			
        	ps.close();
        	ps = this.conn.prepareStatement("SELECT authorId from author where authorName = ?");
        	ps.setString(1, authorName);
        	result = ps.executeQuery();	
        			
        	 while (result.next()) {
	                authorId = result.getInt("authorId");
	                System.out.println(authorId);
	            }
        	 ps.close();
        	 ps = this.conn.prepareStatement("INSERT INTO category (categoryName) VALUES (?);");
         	ps.setString(1, categoryName);
         	isInserted = ps.execute();	
         			
         	ps.close();
         	ps = this.conn.prepareStatement("SELECT categoryId from category where categoryName = ?");
         	ps.setString(1, categoryName);
         	result = ps.executeQuery();	
         			
         	 while (result.next()) {
 	                categoryId = result.getInt("categoryId");
 	                System.out.println(categoryId);
 	            }
         	 ps.close();
         	ps = this.conn.prepareStatement("INSERT INTO publisher (publisherName) VALUES (?);");
        	ps.setString(1, publisherName);
        	isInserted = ps.execute();	
        			
        	ps.close();
        	ps = this.conn.prepareStatement("SELECT publisherId from publisher where publisherName = ?");
        	ps.setString(1, publisherName);
        	result = ps.executeQuery();	
        			
        	 while (result.next()) {
	                publisherId = result.getInt("publisherId");
	                System.out.println(publisherId);
	            }
        	 ps.close();
            ps = this.conn.prepareStatement(
                    "INSERT INTO Book (bookName, authorId,categoryId,publisherId,page,ISBN,publishDate) VALUES (?,?,?,?,?,?,?);");

            ps.setString(1, bookName);
            ps.setInt(2, authorId);
            ps.setInt(3, categoryId);
            ps.setInt(4, publisherId);
            ps.setInt(5, page);
            ps.setInt(6, ISBN);
            ps.setString(7,publishDate);
            int affected = ps.executeUpdate();
            if (affected == 1) {
                System.out.println("added book successfully");
            } else {
                System.out.println("adding book not successful.");
            }
        } finally {
            if (ps != null) {
                ps.close();
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
