import mysql.connector
from tabulate import tabulate


def get_user_credentials():
    username = input("Enter your MySQL username: ")
    password = input("Enter your MySQL password: ")
    return username, password

def connect():
    username, password = get_user_credentials()
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user=username,
            password=password,
            database="FIFAWWorldCup_20908391"
        )
        if conn:
            print("Connected Successfully")
            return conn
    except Exception as e:
        print("Error occurred:", str(e))

def display(connection, query):
    try:
        cursor = connection.cursor()
        cursor.execute(query)
        result = cursor.fetchall()
        header = cursor.column_names
        formatted_table = tabulate(result, header, tablefmt="psql", colalign=("left",))
        print("\n", formatted_table)
        cursor.close()
    except Exception as e:
        print("Error:", str(e))

def menu():
    while True:
        print("\n###############################")
        print("\n#### FIFA WOMENS' WORLD CUP ####")
        print("\n-------MAIN MENU-------")
        print("1. SELECT Function")
        print("2. Defined Queries")
        print("3. Add Record")
        print("4. Update Record")
        print("5. Delete Record")
        print("\nQ. Exit\n")

        choice = input("Enter your choice: ")
    	
        if choice == "1":
            select_function()
        elif choice == "2":
            defined_queries()
        elif choice == "3":
            add_function(conn)
        elif choice == "4":
            update_function(conn)
        elif choice == "5":
            delete_function()
        elif choice == "Q" or choice == "q":
            print("Exiting...")
            break;  
        else:
            print("Invalid choice. Please select a valid option.")
      


def select_function():
    while True:
    	print("\n-------SELECT FUNCTION-------")
    	print("1. Select records from WorldCup")
    	print("2. Select records from Location")
    	print("3. Select records from GroupStage")
    	print("4. Select records from Team")
    	print("5. Select records from Player")
    	print("6. Select records from Matches")
    	print("7. Select records from PlaysIn")
    	print("8. Select records from Awards")
    	print("R. Return to Main Menu")
    
    	choice = input("Enter your choice: ")
    

    	if choice == "1":
            query = "SELECT * FROM WorldCup"
            display(conn, query)
    	elif choice == "2":
            query = "SELECT * FROM Location"
            display(conn, query)
    	elif choice == "3":
            query = "SELECT * FROM GroupStage"
            display(conn, query)
    	elif choice == "4":
            query = "SELECT * FROM Team"
            display(conn, query)
    	elif choice == "5":
            query = "SELECT * FROM Player"
            display(conn, query)
    	elif choice == "6":
            query = "SELECT * FROM Matches"
            display(conn, query)
    	elif choice == "7":
            query = "SELECT * FROM PlaysIn"
            display(conn, query)
    	elif choice == "8":
            query = "SELECT * FROM Awards"
            display(conn, query)
    	elif choice == "R" or choice == "r":
            break
    	else:
            print("Invalid choice. Please try again.")
        


def defined_queries():
    while True:
    	print("\n### Defined Queries ###")
    	print("1. Get players who have scored more than 50 goals in their career.")
    	print("2. Names of teams that have qualified for the next stage in their respective groups.")
    	print("3. Brief summary of each game, including teams, results, and winner.")
    	print("4. Difference in the number of days between the first match of the knockout stage and the final match.")
    	print("5. Teams that have not advanced to the next stage in their respective groups.")
    	print("6. Award winners of the world cup with their respective country, club, and goals.")
    	print("7. Comprehensive information about the venues where the matches were hosted.")
    	print("8. Average goals scored by each team in a specific year.")
    	print("9. Get Players by Country (Stored Procedure)")
    	print("10. Get Average Goals per Team in a Specific Year (Stored Procedure)")
    	print("11. Calculate Win Percentage for a Team in a Specific Year (Stored Procedure)")
    	print("12. Match Results View (View)")
    	print("13. Add Home Team to PlaysIn (Trigger)")
    	print("R. Return to Main Menu")

    	choice = input("Enter your choice: ")

    	if choice == "1":
            query = "SELECT * FROM Player WHERE goals > 50"
            display(conn, query)
    	elif choice == "2":
            query = "SELECT group_name, team FROM GroupStage WHERE qualified = 'Q'"
            display(conn, query)
    	elif choice == "3":
            query = "SELECT CONCAT(homeTeam, ' vs ', awayTeam) AS Matchs, CONCAT(homeScore, ' - ', awayScore) AS Scores, winner AS Winner FROM Matches"
            display(conn, query)
    	elif choice == "4":
            query = "SELECT DATEDIFF((SELECT MAX(m_date) FROM Matches), (SELECT MIN(m_date) FROM Matches WHERE stage = 'Round of 16')) AS days_between_first_and_final_match"
            display(conn, query)
    	elif choice == "5":
            query = "SELECT G.group_name, T.team_name FROM Team T LEFT JOIN GroupStage G ON T.team_name = G.team WHERE G.qualified = 'N' ORDER BY G.group_name"
            display(conn, query)
    	elif choice == "6":
            query = "SELECT DISTINCT P.name, P.country, P.club, P.goals FROM Player AS P WHERE P.playerID IN (SELECT A.playerID FROM Awards AS A) ORDER BY P.goals DESC"
            display(conn, query)
    	elif choice == "7":
            query = "SELECT M.venue, L.stadium_name, L.seat_capacity, M.total_attendance FROM (SELECT venue, SUM(attendance) AS total_attendance FROM Matches GROUP BY venue) AS M JOIN Location AS L ON M.venue = L.name ORDER BY M.total_attendance DESC"
            display(conn, query)
    	elif choice == "8":
            year = input("Enter the World Cup year (e.g., 2019): ")
            query = f"SELECT GS.year, GS.team, SUM(M.homeScore + M.awayScore) AS total_goals_scored FROM GroupStage GS JOIN Matches M ON GS.year = M.year AND (GS.team = M.homeTeam OR GS.team = M.awayTeam) WHERE GS.year = {year} GROUP BY GS.year, GS.team ORDER BY total_goals_scored DESC"
            display(conn, query)
    	elif choice == "9":
            country = input("Enter the country: ")
            query = f"CALL GetPlayersByTeam('{country}')"
            display(conn, query)
    	elif choice == "10":
            year = input("Enter the World Cup year: ")
            query = f"CALL AvgGoalsPerTeam({year})"
            display(conn, query)
    	elif choice == "11":
            team_name = input("Enter the team name: ")
            year = input("Enter the World Cup year: ")
            query = f"CALL CalculateWinPercentage('{team_name}', {year})"
            display(conn, query)
    	elif choice == "12":
            query = "SELECT * FROM MatchResultsView"
            display(conn, query)
    	elif choice == "R" or choice == "r":
    	    break
    	else:
            print("Invalid choice. Please try again.")
            
def add_function(connection):
        print("\n-------ADD RECORD-------")
        table_name = input("Enter the table name: ")
        columns = input("Enter the columns (comma-separated): ").split(',')
        values = input("Enter the values (comma-separated): ").split(',')
        add_data(connection, table_name, columns, values)
            
def add_data(connection, table_name, columns, values):
    	try:
       	    cursor = connection.cursor()
            query = f"INSERT INTO {table_name} ({', '.join(columns)}) VALUES ({', '.join(['%s' for _ in values])})"
            cursor.execute(query, values)
            connection.commit()
            print("Record added successfully.")
    	except Exception as e:
            print("Error:", str(e))
            
def update_function(connection):
    print("\n-------UPDATE RECORDS-------")
    table_name = input("Enter the table name: ")
    condition_column = input("Enter the column to specify the condition: ")
    condition_value = input(f"Enter the value for {condition_column} to identify records to update: ")
    
    # Collect the new values for the record
    columns = input("Enter the columns to update (comma-separated): ").split(',')
    values = input("Enter the new values (comma-separated): ").split(',')
    
    update_records(connection, table_name, columns, values, condition_column, condition_value)

def update_records(connection, table_name, columns, values, condition_column, condition_value):
    try:
        cursor = connection.cursor()
        
        # Construct the UPDATE query with the specified condition
        update_query = f"UPDATE {table_name} SET {', '.join([f'{col} = %s' for col in columns])} WHERE {condition_column} = %s"
        
        # Execute the query, passing the new values and condition value as parameters
        cursor.execute(update_query, values + [condition_value])
        
        # Commit the changes to the database
        connection.commit()
        
        # Check if any rows were affected (updated)
        if cursor.rowcount > 0:
            print(f"{cursor.rowcount} record(s) updated in {table_name}.")
        else:
            print("No records matching the condition were found.")
    
    except Exception as e:
        print("Error:", str(e))

            
def delete_function():
    table_name = input("Enter the table name: ")
    condition_column = input("Enter the column to specify the condition: ")
    condition_value = input(f"Enter the value for {condition_column} to delete records: ")
    
    delete_records(conn, table_name, condition_column, condition_value)
            
def delete_records(connection, table_name, condition_column, condition_value):
    try:
        cursor = connection.cursor()

        # Construct the DELETE query with the specified condition
        delete_query = f"DELETE FROM {table_name} WHERE {condition_column} = %s"

        # Execute the query, passing the condition value as a parameter
        cursor.execute(delete_query, (condition_value,))

        # Commit the changes to the database
        connection.commit()

        # Check if any rows were affected (deleted)
        if cursor.rowcount > 0:
            print(f"{cursor.rowcount} record(s) deleted from {table_name}.")
        else:
            print("No records matching the condition were found.")

    except Exception as e:
        print("Error:", str(e))
        

  

if __name__ == "__main__":
    conn = connect()
    menu()
    
    
