#!/usr/bin/python3
import mysql.connector
from mysql.connector import errorcode
import os

DB_NAME = os.getenv('DB_NAME')

cnx = mysql.connector.connect(
  host=os.getenv('DBHOST'),
  user=os.getenv('DBUSER'),
  passwd=os.getenv('DBPASSWD'),
)

def create_db():
    cursor = cnx.cursor()
    

    TABLES = {}
    TABLES['weather'] = (
        "CREATE TABLE `weather` ("
        "  `id` int(11) NOT NULL,"
        "  `weather_state_name` varchar(8),"
        "  `weather_state_abbr` varchar(8),"
        "  `wind_direction_compass` varchar(8),"
        "  `created` date,"
        "  `applicable_date` date NOT NULL,"
        "  `min_temp` varchar(8),"
        "  `max_temp` varchar(8),"
        "  `the_temp` varchar(8),"
        "  PRIMARY KEY (`applicable_date`)"
        ") ENGINE=InnoDB")


    def create_database(cursor):
        try:
            cursor.execute(
                "CREATE DATABASE {} DEFAULT CHARACTER SET 'utf8'".format(DB_NAME))
        except mysql.connector.Error as err:
            print("Failed creating database: {}".format(err))
            exit(1)

    try:
        cursor.execute("USE {}".format(DB_NAME))
    except mysql.connector.Error as err:
        print("Database {} does not exists.".format(DB_NAME))
        if err.errno == errorcode.ER_BAD_DB_ERROR:
            create_database(cursor)
            print("Database {} created successfully.".format(DB_NAME))
            cnx.database = DB_NAME
        else:
            print(err)
            exit(1)

    for table_name in TABLES:
        table_description = TABLES[table_name]
        try:
            print("Creating table {}: ".format(table_name), end='')
            cursor.execute(table_description)
        except mysql.connector.Error as err:
            if err.errno == errorcode.ER_TABLE_EXISTS_ERROR:
                print("already exists.")
            else:
                print(err.msg)
        else:
            print("OK")

    cursor.close()

def insert_to_table(most_consensus_monthly):
    columns = ', '.join("`" + str(x).replace('/', '_') + "`" for x in most_consensus_monthly.keys())
    values = ', '.join("'" + str(x).replace('/', '_') + "'" for x in most_consensus_monthly.values())
    sql = "REPLACE INTO %s ( %s ) VALUES ( %s );" % ('weather', columns, values)
    print(sql)
    cnx.database = DB_NAME
    cursor = cnx.cursor()
    cursor.execute(sql)
    cnx.commit()
    cursor.close()

def select_all():
    cnx.database = DB_NAME
    cursor = cnx.cursor()
    cursor.execute('SELECT * FROM weather ORDER BY applicable_date ASC')
    result = cursor.fetchall()
    print(result)
    cursor.close()
    # cnx.close()
    return(result)

def user_select(userdate):
    cnx.database = DB_NAME
    cursor = cnx.cursor()
    print(userdate)
    sql = 'SELECT * FROM weather WHERE DATE_FORMAT(applicable_date,"%Y-%m") = %s ORDER BY applicable_date ASC'
    cursor.execute(sql, (userdate,))
    result = cursor.fetchall()
    print(result)
    cursor.close()
    # cnx.close()
    return(result)

