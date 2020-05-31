CREATE KEYSPACE IF NOT EXISTS ks WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 }; 

create table ks.extrato (
    account_id text , 
    tipo_do_lancamento text, 
    transaction_id text, 
    indicador_debito_credito text, 
    moeda text, 
    indicador_fechamento text, 
    canal text,
    literal text, 
    codigo_pesquisa text, 
    id text, 
    valor double, 
    data_movimento timestamp, 
    lote text,
    estabelecimento text,
    metainf text, 
    primary key ((canal), tipo_do_lancamento, codigo_pesquisa, data_movimento, account_id));
