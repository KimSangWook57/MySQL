package sqlconnection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.Scanner;

public class DBmission02 {
	// 전역 변수 선언
	static Connection conn = null;
	static ResultSet rs = null;
	static Scanner sc = new Scanner(System.in);
	static PreparedStatement psmt = null;

	private static void connectDB() {
		// DB 연동 준비
		try {
			// 드라이브 로딩
			Class.forName("com.mysql.cj.jdbc.Driver");
			// DB 연결
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pnwsw42_ksw", "root", "1234");
			System.out.println("db 연결 완료");
		} catch (Exception e) {
			System.out.println("JDBC 드라이버 로딩 중 오류 발생");
			e.printStackTrace();
			return;
		}
	}

	private static void disconnectDB() {
		try {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
			if (conn != null)
				conn.close();
			System.out.println("모든 객체 닫기 완료.");
		} catch (SQLException e) {
			System.out.println("객체 닫는 중 오류 발생.");
			e.printStackTrace();
			return;
		}

	}

	private static void insertUser() {
		System.out.println("================");
		System.out.println("사용자를 추가합니다.");
		System.out.print("사용자번호 입력 : ");
		String uid = sc.next();
		System.out.print("이름 입력 : ");
		String name = sc.next();
		System.out.print("이메일 입력 : ");
		String email = sc.next();

		try {
			psmt = conn.prepareCall("{call InsertUser(?, ?, ?)}");
			psmt.setString(1, uid);
			psmt.setString(2, name);
			psmt.setString(3, email);
			psmt.executeUpdate();
			System.out.println("자료 추가 완료.");
		}
		// 동일한 primary key가 있을 때 예외처리하는 코드.
		catch (SQLIntegrityConstraintViolationException e) {
			System.out.println("동일한 사용자번호가 있습니다. 게시판으로 돌아갑니다.");
		} catch (SQLException e) {
			System.out.println("자료 추가 중 오류 발생.");
			e.printStackTrace();
		}
		System.out.println("================");
	}

	private static void deleteUser() {
		System.out.println("================");
		System.out.print("사용자번호를 입력하세요. : ");
		String uid = sc.next();

		try {
			psmt = conn.prepareCall("{call DeleteUser(?)}");
			psmt.setString(1, uid);
			psmt.executeUpdate();
			System.out.println("사용자번호 " + uid + "번 자료 삭제 완료.");
		} catch (Exception e) {
			System.out.println("삭제 중 오류 발생.");
			e.printStackTrace();
		}
		System.out.println("================");

	}
	
	private static void selectUser() {
		System.out.println("================");
		System.out.print("사용자번호를 입력하세요. : ");
		String uid = sc.next();

		try {
			psmt = conn.prepareCall("{call SelectUser(?)}");
			psmt.setString(1, uid);
			rs = psmt.executeQuery();
			
			System.out.print("검색 결과 => ");
			while (rs.next()) {
				int idx = rs.getInt(1);
				String name = rs.getString(2);
				String email = rs.getString(3);
				System.out.println("사용자번호 : " + idx + ", 이름 : " + name + ", 이메일 : " + email);

			}
		} catch (Exception e) {
			System.out.println("검색 중 오류 발생.");
			e.printStackTrace();
		}
		System.out.println();
		System.out.println("================");
		
	}
	
	private static void updateUser() {
		System.out.println("================");
		System.out.print("사용자번호를 입력하세요. : ");
		String uid = sc.next();
		System.out.print("새로운 이름을 입력하세요. : ");
		String name = sc.next();
		System.out.print("새로운 이메일 주소를 입력하세요. : ");
		String email = sc.next();

		try {
			psmt = conn.prepareCall("{call UpdateUser(?, ?, ?)}");
			psmt.setString(1, uid);
			psmt.setString(2, name);
			psmt.setString(3, email);
			psmt.executeUpdate();
			System.out.println("사용자번호 " + uid + "번 데이터 갱신 완료.");
		} catch (Exception e) {
			System.out.println("갱신 중 오류 발생.");
			e.printStackTrace();
		}
		System.out.println("================");
		
	}

	public static void main(String[] args) {
		connectDB();
		
		int choice = 999;
		// 0을 입력받기 전까지 계속 실행해야 한다.
		while (choice != 0) {
			System.out.println("================");
			System.out.println("user 테이블 게시판");
			System.out.println("1)추가");
			System.out.println("2)삭제");
			System.out.println("3)검색");
			System.out.println("4)수정");
			System.out.println("0)종료");
			System.out.println("================");

			System.out.print("기능 선택 : ");
			choice = sc.nextInt();
			// 입력받은 값에 따라 기능 실행.
			switch (choice) {
			case 1: {
				insertUser();
				break;
			}
			case 2: {
				deleteUser();
				break;
			}
			case 3: {
				selectUser();
				break;
			}
			case 4: {
				updateUser();
				break;
			}
			case 0: {
				System.out.println("게시판을 종료합니다.");
				break;
			}
			default:
				System.out.println("잘못된 숫자 입력입니다. 다시 입력하세요.");
			}
		}
		disconnectDB();
	}

	

}
