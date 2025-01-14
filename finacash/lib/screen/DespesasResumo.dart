import 'package:finacash/Widgets/TimeLineItem.dart';
import 'package:finacash/model/Movimentacoes.dart';
import 'package:finacash/repository/Movimentacoes_repository.dart';
import 'package:flutter/material.dart';

class DespesasResumo extends StatefulWidget {
  @override
  _DespesasResumoState createState() => _DespesasResumoState();
}

class _DespesasResumoState extends State<DespesasResumo> {
  MovimentacoesRepository movimentacoesHelper = MovimentacoesRepository();
  List<Movimentacoes> listmovimentacoes = List();

  _allMovPorTipo() {
    movimentacoesHelper.getAllMovimentacoesPorTipo("d").then((list) {
      setState(() {
        listmovimentacoes = list;
      });
      print("All Mov: $listmovimentacoes");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _allMovPorTipo();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: width * 0.05,top: width * 0.2),
              child: Text("Despesas",style: TextStyle(
                color: Colors.white ,//Colors.grey[400],
                fontWeight: FontWeight.bold,
                fontSize: width * 0.08
              ),),
              
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: width * 0.08),
              child: SizedBox(
                width: width,
                height: height * 0.74,
                child: ListView.builder(
                  itemCount: listmovimentacoes.length,
                  itemBuilder: (context, index){
                    List movReverse = listmovimentacoes.reversed.toList();
                    Movimentacoes mov = movReverse[index];
                    
                    if(movReverse[index] == movReverse.last){
                      return TimeLineItem(mov: mov, colorItem: Colors.red[900],isLast: true,);
                    }else{
                      return TimeLineItem(mov: mov,colorItem: Colors.red[900],isLast: false,);
                    }
                    
                  },
                ),
              ),
              
            ),
            
          ],
        ),
      ),
    );
  }
}
