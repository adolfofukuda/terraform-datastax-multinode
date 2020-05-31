import sys
import json
import uuid
from random import uniform, randint
from datetime import datetime, timezone, timedelta
import argparse

parser = argparse.ArgumentParser(description='Gerador de extrato.')
parser.add_argument('-r', '--registros', help='Quantos registros gerar', required=True)
parser.add_argument('-a', '--arquivo', help='Arquivo destino dos registros', required=True)
parser.add_argument('--diff', help='Tempo em milissegundos entre cada registro', required=True)
parser.add_argument('--canal', help='Canal para todos os registros')
parser.add_argument('--literal', help='Literal para todos os registros')
parser.add_argument('--codigo', help='Codigo de pesquisa para todos os registros')
parser.add_argument('--lote', help='Lote para todos os registros')
parser.add_argument('--api', help='Rest API para post do registro')
parser.add_argument('--conta', help='ID uuidv4 para conta')

args = parser.parse_args()

total=int(args.registros)
arquivo=args.arquivo
diff=int(args.diff)

canal=args.canal
literal=args.literal
codigo=args.codigo

lote=args.lote

api=args.api

conta=args.conta

headers={"Content-Type" : "application/json"}

dataBase = datetime.now(timezone.utc)

f = open(arquivo + ".cvs", "a")
j = open(arquivo + ".json", "a")

for x in range(total):
    data = {}
    date_format = "%Y-%m-%dT%H:%M:%S.%fZ" 

    if conta is None:
        data['account_id'] = str(uuid.uuid4())
    else:
        data['account_id'] = conta

    data['tipo_do_lancamento'] = 'lancamento'
    data['transaction_id'] = str(uuid.uuid4())
    data['indicador_debito_credito'] = 'C'
    data['moeda'] = 'BRL'
    data['indicador_fechamento'] = '1'

    if canal is None:
        data['canal'] = "mobile"
    else:
        data['canal'] = canal

    if literal is None:
        data['literal'] = "Um literal " + str(x) + " para extrato "
    else:
        data['literal'] = literal

    if codigo is None:
        data['codigo_pesquisa'] = "este-e-um-codigo-nt0x8-" + str(x) + "r"
    else:
        data['codigo_pesquisa'] = codigo

    data['id'] = str(uuid.uuid4())
    data['valor'] = uniform(0, 100000)

    dataBase = dataBase - timedelta(milliseconds=diff)
    data['data_movimento'] = dataBase.astimezone().strftime(date_format)

    if lote is None:
        data['lote'] = 'l-' + str(x * 2)
    else:
        data['lote'] = lote

    # geopoint
    lat = randint(0, 180) -90
    lon = randint(0, 360) -180

    #data['localizacao'] = {}
    #data['localizacao']['lat'] = lat
    #data['localizacao']['lon'] = lon
    
    data['estabelecimento'] = "Este e um estabelecimento " + str(x)

    data['metainf'] = 'eyJ2YWxvciI6MjA1NzUuNTk4NDEzOTIxMTM2LCJkYXRhT3BlcmFjYW8iOiIyMDIwLTA1LTEyVDE3OjU1OjA5LjQ1ODUxOC0wMzowMCIsImxpdGVyYWwiOiJVbSBsaXRlcmFsIDAgcGFyYSBleHRyYXRvICIsImlkIjoiNDM3NWY5NmMtYzg1NC00YTc3LWE3MDUtMGNmYWZjMTdkMWI2IiwiY29kaWdvIjoibnQweDgtMHIiLCJlc3RhYmVsZWNpbWVudG8iOiJlc3RhYi0wIiwiY2FuYWwiOiJtb2JpbGUiLCJs'
    
    json.dump(data, j)
    f.write(data['account_id'] + ';' + data['tipo_do_lancamento'] + ';' + data['transaction_id'] + ';' + data['indicador_debito_credito'] + ';' + data['moeda'] + ';' + data['indicador_fechamento'] + ';' + data['canal'] + ';' + data['literal'] + ';' + data['codigo_pesquisa'] + ';' + data['id'] + ';' + str(data['valor']) + ';' + data['data_movimento'] + ';' + data['lote'] + ';' + data['estabelecimento'] + ';' + data['metainf'] + '\n')

    j.write("\n")

j.close()
f.close()
