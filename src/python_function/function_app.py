import azure.functions as func
from azure.data.tables import TableClient, UpdateMode
import logging
import os
import json

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)
connection_string = os.environ['CONNECTION_STRING']
PARTITION_KEY = 'partition1'
ROW_KEY = 'row1'
TABLE_NAME = 'visitorcount'
SELECT = 'count'

@app.route(route="visitor_trigger")
def visitor_trigger(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    
    if not connection_string:
        logging.info('Connection string to table storage not found')
        return func.HttpResponse(f"connection string not found")
    
    try:
        # initialize table client with table needed
        table_client = TableClient.from_connection_string(conn_str=connection_string, table_name=TABLE_NAME)

        # query entity from table
        entity = table_client.get_entity(partition_key=PARTITION_KEY, row_key=ROW_KEY, select=SELECT)
    except:
        return func.HttpResponse(f"error creating table and/or retrieving entity")
    

    # create new entity and update with existing
    increment_entity = {
        'PartitionKey': PARTITION_KEY,
        'RowKey': ROW_KEY,
        'count': entity[SELECT] + 1
    }

    table_client.update_entity(entity=increment_entity,mode=UpdateMode.MERGE)
    return func.HttpResponse(json.dumps(entity), mimetype='application/json', charset='utf-8')