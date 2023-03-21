package sqlconnection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.Scanner;

public class DBmission01 {

	public static void main(String[] args) {

		// 변수 선언
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		Scanner sc = new Scanner(System.in);
		int choice = 999;

		// DB 연동 준비
		try {
			// 드라이브 로딩
			Class.forName("com.mysql.cj.jdbc.Driver");

			// DB 연결
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db0321", "root", "1234");
		} catch (Exception e) {
			System.out.println("JDBC 드라이버 로딩 중 오류 발생");
			e.printStackTrace();
			return;
		}

		// 0을 입력받기 전까지 계속 실행해야 한다.
		while (choice != 0) {
			System.out.println("================");
			System.out.println("user 테이블 게시판");
			System.out.println("1)자료 추가");
			System.out.println("2)자료 전체 검색");
			System.out.println("3)id로 자료 검색");
			System.out.println("4)id로 자료 삭제");
			System.out.println("5)id로 이메일 갱신");
			System.out.println("0)종료");
			System.out.println("================");

			System.out.print("기능 선택 : ");
			choice = sc.nextInt();
			// 입력받은 값에 따라 기능 실행.
			switch (choice) {
			case 1: {
				System.out.println("================");
				System.out.println("자료를 추가합니다.");
				System.out.print("id번호 입력 : ");
				int id = sc.nextInt();
				System.out.print("이름 입력 : ");
				String name = sc.next();
				System.out.print("이메일 입력 : ");
				String email = sc.next();

				try {
					psmt = conn.prepareStatement("insert into user values(" + id + ", '" + name + "', '" + email + "')");
//					psmt = conn.prepareStatement("insert into user values(?,?,?)");
//					psmt.setInt(1, id);
//					psmt.setString(2, name);
//					psmt.setString(3, email);
					
					psmt.executeUpdate();
					System.out.println("자료 추가 완료.");
				}
				// 동일한 primary key가 있을 때 예외처리하는 코드.
				catch (SQLIntegrityConstraintViolationException e) {
					System.out.println("동일한 id번호가 있습니다. 게시판으로 돌아갑니다.");
				} catch (SQLException e) {
					System.out.println("자료 추가 중 오류 발생.");
					e.printStackTrace();
				}
				System.out.println("================");
				break;
			}
			case 2: {
				System.out.println("================");
				System.out.println("전체 자료를 출력합니다.");

				try {
					psmt = conn.prepareStatement("select * from user");
					rs = psmt.executeQuery();

					while (rs.next()) {
						int id = rs.getInt(1);
						String name = rs.getString(2);
						String email = rs.getString(3);
						System.out.println("유저번호 : " + id + ", 이름 : " + name + ", 이메일 : " + email);

					}
				} catch (Exception e) {
					System.out.println("자료 검색 중 오류 발생.");
					e.printStackTrace();
				}
				System.out.println("================");
				break;
			}
			case 3: {
				System.out.println("================");
				System.out.print("id번호를 입력하세요. : ");
				int id = sc.nextInt();

				try {
					psmt = conn.prepareStatement("select * from user where id = '" + id + "';");
					// psmt = conn.prepareStatement("select * from user where id = ?");
					// psmt.setInt(1, id);
					rs = psmt.executeQuery();
					// 가져올 값이 없을 때의 코드.
					if (!rs.next()) {
						System.out.println("유저번호 " + id + "번 자료가 없습니다. 게시판으로 돌아갑니다.");
						System.out.println("================");
						break;
					}

					System.out.print("검색 결과 => ");
					while (rs.next()) {
						int idx = rs.getInt(1);
						String name = rs.getString(2);
						String email = rs.getString(3);
						System.out.println("유저번호 : " + idx + ", 이름 : " + name + ", 이메일 : " + email);

					}
				} catch (Exception e) {
					System.out.println("검색 중 오류 발생.");
					e.printStackTrace();
				}
				System.out.println("================");
				break;
			}
			case 4: {
				System.out.println("================");
				System.out.print("id번호를 입력하세요. : ");
				int id = sc.nextInt();

				try {
					psmt = conn.prepareStatement("delete from user where id = '" + id + "';");
					// psmt = conn.prepareStatement("delete from user where id = ?");
					// psmt.setInt(1, id);
					psmt.executeUpdate();
					// 가져올 값이 없을 때의 코드.
					if (!rs.next()) {
						System.out.println("유저번호 " + id + "번 자료가 없습니다. 게시판으로 돌아갑니다.");
						System.out.println("================");
						break;
					}

					System.out.println("유저번호 " + id + "번 자료 삭제 완료.");
				} catch (Exception e) {
					System.out.println("삭제 중 오류 발생.");
					e.printStackTrace();
				}
				System.out.println("================");
				break;
			}
			case 5: {
				System.out.println("================");
				System.out.print("id번호를 입력하세요. : ");
				int id = sc.nextInt();

				System.out.println("새로운 이메일 주소를 입력하세요. : ");
				String email = sc.next();

				try {
					psmt = conn.prepareStatement("update user set email = '" + email + "' where id = '" + id + "';");
					// psmt = conn.prepareStatement("update user set email = ? where id = ?");
					// psmt.setString(1, email);
					// psmt.setInt(2, id);
					psmt.executeUpdate();
					// 가져올 값이 없을 때의 코드.
					if (!rs.next()) {
						System.out.println("유저번호 " + id + "번 자료가 없습니다. 게시판으로 돌아갑니다.");
						System.out.println("================");
						break;
					}

					System.out.println("유저번호 " + id + "번 이메일 갱신 완료.");
				} catch (Exception e) {
					System.out.println("갱신 중 오류 발생.");
					e.printStackTrace();
				}
				System.out.println("================");
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

		try {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
			if (conn != null)
				conn.close();
		} catch (SQLException e) {
			System.out.println("객체 닫는 중 오류 발생.");
			e.printStackTrace();
			return;
		}

	}

}
