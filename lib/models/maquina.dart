part of aristadart;

class Maquina extends Ref
{
    @Field() String get href => localHost + Col.maquina + '/$id';
    
    @Field() User owner;
    @Field() String descripcion;
    @Field() List<FileDb> fotos;
    @Field() String marca;
    @Field() String modelo;
    @Field() String categoria;
    @Field() String subcategoria;
    @Field() DateTime fabricacion;
    @Field() num precio;
}

class ListMaquinaResp extends Resp
{
    @Field() List<Maquina> maquinas;
}