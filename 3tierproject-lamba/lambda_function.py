import mysql.connector
import os

def lambda_handler(event, context):
    # Database connection details
    db_host = os.environ['DB_HOST']
    db_user = os.environ['DB_USER']
    db_password = os.environ['DB_PASSWORD']

    # Read queries from a file
    with open('test.sql', 'r') as file:
        queries = file.read()

    # Connect to the database
    connection = mysql.connector.connect(
        host=db_host,
        user=db_user,
        password=db_password,
    )

    try:
        with connection.cursor() as cursor:
            for query in queries.split(';'):
                if query.strip():
                    cursor.execute(query)
                    connection.commit()
        return {"statusCode": 200, "message": "Queries executed successfully"}
    except Exception as e:
        return {"statusCode": 500, "error": str(e)}
    finally:
        connection.close()
