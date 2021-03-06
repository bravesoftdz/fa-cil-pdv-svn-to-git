unit unECF;

interface

uses
  Windows, SysUtils, Controls, Messages, Forms, Dialogs, Classes,
  Shellapi;


type
  // Matrizes (Records)
  tipo_parametro = record
    Nome: string;
    Conteudo: string;
    Tipo: integer;
  end;
  // Totalizadores Parciais (aliquotas) retornado do ECF
  TTotalizador = record
    Nome: string[20];
    Valor: Real;
  end;
var
  (* Retorno do ECF *)
  IRetorno: Integer;
  BRetorno: Boolean;
  iACK, iST1, iST2: Integer;
  Handle: THandle;
  ecfMSG: string;
  nporta: integer;
  sMsg: string;

    (* Arrays Diversos*)
  tbTotalizador: array[1..50] of TTotalizador;
  aRelatoriosGerenciais: array[1..50, 1..2] of string;

function Executa_programa(const FileName, Params: string; const WindowState: Word): boolean;
(***************************** FUNCOES ****************************************)

// Retornos
function cECF_Analisa_Retorno(COD_ECF: Integer): string;
function cECF_Retorno_Impressora(COD_ECF: Integer): string;
// Inicializacao

function cECF_Abre(COD_ECF: Integer; Porta: string): string;
function cECF_Fecha(COD_ECF: Integer): string;

// Informacoes e Status
function cECF_Ligada(COD_ECF: Integer): string;
function cECF_Numero_Serie(COD_ECF: Integer): string;
function cECF_Numero_Caixa(COD_ECF: Integer): string;
function cECF_Numero_Cupom(COD_ECF: Integer): string;
function cECF_COO_Nao_Fiscal(COD_ECF: Integer): string;
function cECF_Numero_Contador_Cupom(COD_ECF: Integer): string;
function cECF_Numero_Contador_Relatorio_Gerencial(COD_ECF: integer): string;
function cECF_Numero_Contador_Operacao_NF(COD_ECF: integer): string;
function cECF_Numero_Contador_Comprovante_CD(COD_ECF: integer): string;
function cECF_Numero_Contador_Gerencial(COD_ECF: integer): string;
function cECF_Data_Hora(COD_ECF: Integer): string;

function cECF_Download(COD_ECF: Integer; tipo: string; Inicio: string;
  Fim: string): string;

function cECF_Registro60A(COD_ECF: Integer): string;
function cECF_Registro60M(COD_ECF: Integer): string;
function cECF_Le_Formas_Pgto(COD_ECF: Integer): string;
function cECF_Arquivo_Fiscal_CAT52(COD_ECF: integer; tipo, inicio, fim: string): string;
function cECF_Marca_ECF(COD_ECF: integer): string;
function cECF_Modelo_ECF(COD_ECF: integer): string;
function cECF_Tipo_ECF(COD_ECF: integer): string;
function cECF_MF_Adicional(COD_ECF: integer): string;
function cECF_Versao_SB(COD_ECF: integer): string;
function cECF_Data_Hora_SB(COD_ECF: integer): string;
function cECF_Total_Cupom(COD_ECF: integer): real;
function cECF_Verifica_Z_automatico(COD_ECF: integer): string;
function cECF_Verifica_Horario_Verao(COD_ECF: integer): string;
function cECF_Verifica_Aliquotas(COD_ecf: integer): string;
function cECF_Verifica_Totalizadores_NF(COD_ECF: integer): string;
function cECF_Data_Movimento(cod_ECF: integer): string;
function cECF_Cupom_Fiscal_Aberto(cod_ECF: integer): string;
function cECF_Grande_Total(cod_ECF: integer): string;
function cECF_VerificarRelatoriosGerenciais(COD_ECF: Integer): string;

// Informacoes ref. reducao Z
function cECF_ReducaoZ_Contador_CRZ(COD_ECF: integer): string;
function cECF_ReducaoZ_Contador_COO(COD_ECF: integer): string;
function cECF_ReducaoZ_Contador_CRO(COD_ECF: integer): string;
function cECF_ReducaoZ_DataHora(COD_ECF: integer): string;
function cECF_ReducaoZ_Data_Movimento(COD_ECF: integer): string;
function cECF_ReducaoZ_Venda_Bruta(COD_ECF: integer): string;
function cECF_ReducaoZ_Total_ISS(COD_ECF: integer): string;
function cECF_ReducaoZ_Totalizador_Geral(COD_ECF: integer): string;
function cECF_ReducaoZ_Totalizador_Parcial(COD_ECF: Integer): string;
// Relatorios
function cECF_LeituraX(COD_ECF: Integer): string;
function cECF_ReducaoZ(COD_ECF: Integer): string;
function cECF_Leitura_Memoria_Fiscal(COD_ECF: INTEGER;
  Tipo: string; // DATA ou CRZ
  Analitica_ou_Sintetica: string; // A ou S
  Ecf_ou_Arquivo: string; // ECF ou ARQUIVO
  Inicio: string; Fim: string): string;
// Cupom
function cECF_Abre_Cupom(COD_ECF: Integer; CPF, Nome, Endereco: string;
  pbImprimirNoCabecalho: Boolean = False): string;
function cECF_Vende_item(COD_ECF: Integer; Codigo, produto, unidade, aliquota: string; quantidade, valor_unitario, valor_desconto: real; valor_acrescimo: real; tipo_desconto_acrescimo: string; total: real): string;
function cECF_Inicia_Fechamento(COD_ECF: Integer; Acrescimo_ou_Desconto: string; tipo: string; valor: real): string;
function cECF_Forma_Pgto(COD_ECF: Integer; forma_pgto: string; valor: real): string;
function cECF_Termina_Fechamento(COD_ECF: Integer; mensagem: string): string;
function cECF_Fecha_Cupom_Resumido(COD_ECF: Integer; forma_pgto: string; mensagem: string; Valor: Currency = 0.00): string;
function cECF_Cancela_Cupom(COD_ECF: Integer): string;
function cECF_Cancela_Item(COD_ECF: Integer; Item: string): string;
// Opera��es N�o Fiscal
function cECF_Abre_Gerencial(COD_ECF: Integer; Texto: string): string;
function cECF_Usa_Gerencial(COD_ECF: Integer; Texto: string): string;
function cECF_Fecha_Gerencial(COD_ECF: Integer): string;
function cECF_Abre_CNFV(COD_ECF: Integer; Forma_Pgto: string; Valor: real; Numero_Cupom: string): string;
function cECF_Usa_CNFV(COD_ECF: Integer; Texto: string): string;
function cECF_Fecha_CNFV(COD_ECF: Integer): string;
function cECF_Sangria(COD_ECF: Integer; Valor: real): string;
function cECF_Suprimento(COD_ECF: Integer; Valor: real; Forma_Pgto: string): string;
function cECF_Recebimento(COD_ECF: Integer; Totalizador: string; Valor: real; Forma_Pgto: string): string;
// Programacao
function cECF_Programa_Horario_Verao(COD_ECF: integer): string;
function cECF_Programa_Aliquota(COD_ECF: integer; aliquota: real; ICMS_ou_ISS: string): string;
function cECF_Programa_Totalizador(COD_ECF: Integer; Indice: integer; descricao: string): string;
function cECF_Programa_Forma_Pgto(COD_ECF: Integer; Forma_Pgto: string; Vinculado: string): string;
function cECF_Daruma_Libera_Porta(SIM_NAO: string): string;
function cECF_Programa_Z_Automatico(COD_ECF: INTEGER; SIM_NAO: string): string;
// Outros
function cECF_Status_Gaveta(COD_ECF: integer): string;
function cECF_Abre_Gaveta(COD_ECF: integer): string;
function cECF_Desliga_Janelas(COD_ECF: integer): string;
(******************************************************************************)

(************************** IMPRESSORAS IMPLEMENTADAS *************************
1  - Bematech - Todos os Modelos
2  - Daruma
3  - SWEDA???
4  - EPSON

// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //

(**************************        bematech           *************************)
// Retornos
function Bematech_FI_RetornoImpressora(var ACK: Integer; var ST1: Integer; var ST2: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
// Informacoes e Status
function Bematech_FI_NumeroSerieMFD(NumeroSerie: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_SubTotal(SubTotal: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_NumeroCupom(NumeroCupom: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_ContadorCupomFiscalMFD(CuponsEmitidos: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_ContadorRelatoriosGerenciaisMFD(Relatorios: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_NumeroOperacoesNaoFiscais(NumeroOperacoes: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_ContadorComprovantesCreditoMFD(Comprovantes: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_NumeroCaixa(NumeroCaixa: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_DataHoraImpressora(Data: string; Hora: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_VerificaEstadoImpressora(var ACK: Integer; var ST1: Integer; var ST2: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_VerificaRelatorioGerencialMFD(Relatorios: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_VerificaImpressoraLigada: Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_VerificaImpressoraLigada';
function Bematech_FI_DownloadMFD(Arquivo: string; TipoDownload: string; ParametroInicial: string; ParametroFinal: string; UsuarioECF: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_FormatoDadosMFD(ArquivoOrigem: string; ArquivoDestino: string; TipoFormato: string; TipoDownload: string; ParametroInicial: string; ParametroFinal: string; UsuarioECF: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_RelatorioTipo60Analitico: Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_RelatorioTipo60Analitico';
function Bematech_FI_RelatorioTipo60Mestre: Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_RelatorioTipo60Mestre';
function Bematech_FI_MarcaModeloTipoImpressoraMFD(Marca, Modelo, Tipo: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_DataHoraGravacaoUsuarioSWBasicoMFAdicional(dataUsuario, dataSWBasico, MFAdicional: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_VersaoFirmwareMFD(VersaoFirmware: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_DadosUltimaReducaoMFD(DadosReducao: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_VerificaFormasPagamentoMFD(FormasPagamento: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_DataHoraReducao(Data: string; Hora: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_VendaBruta(Valor: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_MapaResumoMFD: Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_MapaResumoMFD';
function Bematech_FI_VerificaAliquotasIss(Flag: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_VerificaReducaoZAutomatica(Flag: SHORT): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_FlagsFiscais(var Flag: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_RetornoAliquotas(Aliquotas: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_VerificaTotalizadoresNaoFiscais(Totalizadores: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_DataMovimento(Data: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_GrandeTotal(GrandeTotal: string): Integer; StdCall; External 'BEMAFI32.DLL';
// Ato Cotepe
function Bematech_FI_HabilitaDesabilitaRetornoEstendidoMFD(FlagRetorno: string): Integer; StdCall; External 'BEMAFI32.DLL';
function BemaGeraRegistrosTipoE(cArqMFD: string; cArqTXT: string; cDataInicial: string; cDataFinal: string; cRazao: string; cEndereco: string; cPAR1: string; cCMD: string; cPAR2: string; cPAR3: string; cPAR4: string; cPAR5: string; cPAR6: string; cPAR7: string; cPAR8: string; cPAR9: string; cPAR10: string; cPAR11: string; cPAR12: string; cPAR13: string; cPAR14: string): Integer; StdCall; External 'BemaMFD2.dll';
function Bematech_FI_RetornoImpressoraMFD(var ACK: Integer; var ST1: Integer; var ST2: Integer; var ST3: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
// Relatorios Gerenciais
function Bematech_FI_LeituraX: Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_ReducaoZ(Data: string; Hora: string): Integer; StdCall; External 'BEMAFI32.DLL';

function Bematech_FI_LeituraMemoriaFiscalDataMFD(DataInicial, DataFinal, FlagLeitura: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_LeituraMemoriaFiscalReducaoMFD(ReducaoInicial, ReducaoFinal, FlagLeitura: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_LeituraMemoriaFiscalSerialDataMFD(DataInicial, DataFinal, FlagLeitura: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_LeituraMemoriaFiscalSerialReducaoMFD(ReducaoInicial, ReducaoFinal, FlagLeitura: string): Integer; StdCall; External 'BEMAFI32.DLL';

function Bematech_FI_GeraRegistrosCAT52MFDEx(Arquivo: string; Data: string; cArqDestino: string): Integer; StdCall; External 'BEMAFI32.DLL';
// Cupom
function Bematech_FI_AbreCupomMFD(CGC: string; Nome: string; Endereco: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_VendeItemDepartamento(Codigo: string; Descricao: string; Aliquota: string; ValorUnitario: string; Quantidade: string; Acrescimo: string; Desconto: string; IndiceDepartamento: string; UnidadeMedida: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_CancelaItemGenerico(NumeroItem: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_CancelaCupom: Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_IniciaFechamentoCupom(AcrescimoDesconto: string; TipoAcrescimoDesconto: string; ValorAcrescimoDesconto: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_EfetuaFormaPagamento(FormaPagamento: string; ValorFormaPagamento: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_TerminaFechamentoCupom(Mensagem: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_FechaCupomResumido(FormaPagamento: string; Mensagem: string): Integer; StdCall; External 'BEMAFI32.DLL';
// Opera��es N�o Fiscal
function Bematech_FI_AbreComprovanteNaoFiscalVinculado(FormaPagamento: string; Valor: string; NumeroCupom: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_UsaComprovanteNaoFiscalVinculado(Texto: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_FechaComprovanteNaoFiscalVinculado: Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_Sangria(Valor: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_Suprimento(Valor: string; FormaPagamento: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_RecebimentoNaoFiscal(IndiceTotalizador: string; Valor: string; FormaPagamento: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_RelatorioGerencial(Texto: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_FechaRelatorioGerencial: Integer; StdCall; External 'BEMAFI32.DLL';

// Configura��o / Programa��o
function Bematech_FI_ProgramaAliquota(Aliquota: string; ICMS_ISS: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_ProgramaHorarioVerao: Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_NomeiaTotalizadorNaoSujeitoIcms(Indice: Integer; Totalizador: string): Integer; StdCall; External 'BEMAFI32.DLL';
function Bematech_FI_ProgramaFormaPagamentoMFD(FormaPagto, OperacaoTef: string): Integer; StdCall; External 'BEMAFI32.DLL';


// Outros
function Bematech_FI_AcionaGaveta: Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_AcionaGaveta';
function Bematech_FI_VerificaEstadoGaveta(var EstadoGaveta: Integer): Integer; StdCall; External 'BEMAFI32.DLL';

// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //

(**************************        daruma             *************************)
//Inicializacao
function Daruma_FI_AbrePortaSerial: Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_FechaPortaSerial: Integer; StdCall; External 'Daruma32.dll'
// Retornos
function Daruma_FI_RetornoImpressora(var ACK: Integer; var ST1: Integer; var ST2: Integer): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_RetornaErroExtendido(ErroExtendido: string): Integer; StdCall; External 'Daruma32.dll';
// Informacoes e Status
function Daruma_FI_NumeroSerie(NumeroSerie: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_SubTotal(SubTotal: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_NumeroCupom(NumeroCupom: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_NumeroCaixa(NumeroCaixa: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_DataHoraImpressora(Data: string; Hora: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_VerificaEstadoImpressora(var ACK: Integer; var ST1: Integer; var ST2: Integer): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_VerificaImpressoraLigada: Integer; StdCall; External 'Daruma32.dll'
function Daruma_FIMFD_DownloadDaMFD(CoInicial: string; CoFinal: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_RelatorioTipo60Analitico: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_RelatorioTipo60Analitico';
function Daruma_FI_RelatorioTipo60Mestre: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_RelatorioTipo60Mestre';
function Daruma_FI_VerificaFormasPagamentoEx(FormasEx: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FIMFD_RetornaInformacao(Indice: string; Valor: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_DataHoraReducao(Data: string; Hora: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_LerAliquotasComIndice(AliquotasComIndice: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_SaldoAPagar(SaldoAPagar: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_Registry_RetornaValor(Produto: string; Chave: string; Valor: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_VerificaHorarioVerao(HoraioVerao: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_RetornoAliquotas(Aliquotas: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_VerificaTotalizadoresNaoFiscais(Totalizadores: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_DataMovimento(Data: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_StatusCupomFiscal(StatusCupomFiscal: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_GrandeTotal(GrandeTotal: string): Integer; StdCall; External 'Daruma32.dll';

// Relatorios Gerenciais
function Daruma_FI_LeituraX: Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_ReducaoZ(Data: string; Hora: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_LeituraMemoriaFiscalData(Data_Inicial: string; Data_Final: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_LeituraMemoriaFiscalReducao(Reducao_Inicial: string; Reducao_Final: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_LeituraMemoriaFiscalSerialData(Data_Inicial: string; Data_Final: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_LeituraMemoriaFiscalSerialReducao(Reducao_Inicial: string; Reducao_Final: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_Registry_MFD_LeituraMFCompleta(Valor: string): Integer; StdCall; External 'Daruma32.dll'
function Daruma_FI_MapaResumo: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_MapaResumo';
// Cupom
function Daruma_FI_AbreCupom(CPF_ou_CNPJ: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_VendeItemDepartamento(Codigo: string; Descricao: string; Aliquota: string; Valor_Unitario: string; Quantidade: string; Valor_do_Desconto: string; Valor_do_Acrescimo: string; Indice_Departamento: string; Unidade_Medida: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_CancelaItemGenerico(Numero_Item: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_CancelaCupom: Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_IniciaFechamentoCupom(Acrescimo_ou_Desconto: string; Tipo_do_Acrescimo_ou_Desconto: string; Valor_do_Acrescimo_ou_Desconto: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_EfetuaFormaPagamento(Descricao_da_Forma_Pagamento: string; Valor_da_Forma_Pagamento: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_TerminaFechamentoCupom(Mensagem_Promocional: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_IdentificaConsumidor(Nome_do_Consumidor: string; Endereco: string; CPF_ou_CNPJ: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_FechaCupomResumido(Descricao_da_Forma_de_Pagamento: string; Mensagem_Promocional: string): Integer; StdCall; External 'Daruma32.dll';
// Opera��es N�o Fiscal
function Daruma_FI_AbreComprovanteNaoFiscalVinculado(Forma_de_Pagamento: string; Valor_Pago: string; Numero_do_Cupom: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_UsaComprovanteNaoFiscalVinculado(Texto_Livre: string): Integer; StdCall; External 'Daruma32.dll'
function Daruma_FI_FechaComprovanteNaoFiscalVinculado: Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_Sangria(Valor_da_Sangria: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_Suprimento(Valor_do_Suprimento: string; Forma_de_Pagamento: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_RecebimentoNaoFiscal(Indice_do_Totalizador: string; Valor_do_Recebimento: string; Forma_de_Pagamento: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_RelatorioGerencial(Texto_Livre: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_FechaRelatorioGerencial: Integer; StdCall; External 'Daruma32.dll';

// Configura��o / Programa��o
function Daruma_FI_ProgramaAliquota(Valor_Aliquota: string; Tipo_Aliquota: Integer): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_ProgramaHorarioVerao: Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_NomeiaTotalizadorNaoSujeitoIcms(Indice_do_Totalizador: Integer; Nome_do_Totalizador: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_Registry_AlteraRegistry(Chave: string; ValorChave: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_Registry_ZAutomatica(ZAutomatica: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_CfgRedZAutomatico(Flag: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_FI_ProgramaFormasPagamento(Descricao_das_Formas_Pagamento: string): Integer; StdCall; External 'Daruma32.dll';
Function Daruma_Registry_AplMensagem1(Str_AplMensagem_1: String) : Integer; StdCall; External 'Daruma32.dll';
 Function Daruma_Registry_AplMensagem2(Str_AplMensagem_2: String) : Integer; StdCall; External 'Daruma32.dll';
// Outros
function Daruma_FI_AcionaGaveta: Integer; StdCall; External 'Daruma32.dll'
function Daruma_FI_VerificaEstadoGaveta(var Estado_Gaveta: Integer): Integer; StdCall; External 'Daruma32.dll';
// RSA
function Daruma_RSA_CarregaChavePrivada_Arquivo(Arquivo: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_RSA_RetornaChavePublica(N: string; E: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_RSA_CodificaInformacao(Texto: string; Codigo: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_RSA_DecodificaInformacao(Codigo: string; Texto: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_RSA_CodificaInformacao_Hexa(Texto: string; Codigo: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_RSA_DecodificaInformacao_Hexa(Codigo: string; Texto: string): Integer; StdCall; External 'Daruma32.dll';
function Daruma_RSA_CriarAssinatura(caminhoDoArquivo: string; sMD5: string; sAssinaturaEletronica: string): Integer; StdCall; External 'Daruma32.dll';

// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //

(**************************       SWEDA               *************************)
// Inicializacao
function ECF_AbrePortaSerial: Integer; StdCall; External 'CONVECF.dll';
function ECF_FechaPortaSerial: Integer; StdCall; External 'CONVECF.dll';
// Retornos
function ECF_RetornoImpressora(var ACK: Integer; var ST1: Integer; var ST2: Integer): Integer; StdCall; External 'CONVECF.DLL';
// Informacoes e Status
function ECF_NumeroSerie(NumeroSerie: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_NumeroSerieMFD(NumeroSerie: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_SubTotal(SubTotal: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_NumeroCupom(NumeroCupom: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_NumeroCaixa(NumeroCaixa: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_DataHoraImpressora(Data: string; Hora: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_VerificaEstadoImpressora(var ACK: Integer; var ST1: Integer; var ST2: Integer): Integer; StdCall; External 'CONVECF.DLL';
function ECF_VerificaImpressoraLigada: Integer; StdCall; External 'CONVECF.DLL' Name 'ECF_VerificaImpressoraLigada';
function ECF_DownloadMFD(Arquivo: string; TipoDownload: string; ParametroInicial: string; ParametroFinal: string; UsuarioECF: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_FormatoDadosMFD(ArquivoOrigem: string; ArquivoDestino: string; TipoFormato: string; TipoDownload: string; ParametroInicial: string; ParametroFinal: string; UsuarioECF: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_RelatorioTipo60Analitico: Integer; StdCall; External 'CONVECF.DLL' Name 'ECF_RelatorioTipo60Analitico';
function ECF_RelatorioTipo60Mestre: Integer; StdCall; External 'CONVECF.DLL' Name 'ECF_RelatorioTipo60Mestre';
function ECF_DataMovimento(Livre: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_RetornoAliquotas(Aliquotas: Pchar): Integer; StdCall; External 'CONVECF.DLL';
function ECF_VersaoFirmwareMFD(Versao: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_VerificaFormasPagamentoEx(FormasPag: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_DataHoraGravacaoUsuarioSWBasicoMFAdicional(dataUsuario, dataSWBasico, MFAdicional: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_GrandeTotal(Texto: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_MapaResumoMFD: Integer; StdCall; External 'CONVECF.DLL';
function ECF_ContadorCupomFiscalMFD(Valor: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_ContadorRelatoriosGerenciaisMFD(Valor: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_VerificaRelatorioGerencialMFD(Relats: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_NumeroOperacoesNaoFiscais(Valor: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_ContadorComprovantesCreditoMFD(Valor: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_MarcaModeloTipoImpressoraMFD(Marca: string; Modelo: string; Tipo: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_Registry_RetornaValor(Produto: string; Chave: string; Valor: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_VerificaHorarioVerao(Tipo: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_VerificaTotalizadoresNaoFiscaisEx(Nomes: Pchar): Integer; StdCall; External 'CONVECF.DLL';
function ECF_StatusCupomFiscal(Tipo: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_VerificaAliquotasIss(Flag: string): Integer; StdCall; External 'CONVECF.DLL';
// Ato copete 17/04
function ECF_ReproduzirMemoriaFiscalMFD(tipo, FxaIni, FxaFim, PatTxt, PatBin: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_DownloadMF(nome: string): Integer; StdCall; External 'CONVECF.dll';

// Informacoes da ultima reducao z
function ECF_DadosUltimaReducaoMFD(Texto: PChar): Integer; StdCall; External 'CONVECF.DLL';
function ECF_DataHoraReducao(Data: string; Hora: string): Integer; StdCall; External 'CONVECF.DLL';

// Relatorios Gerenciais
function ECF_LeituraX: Integer; StdCall; External 'CONVECF.DLL';
function ECF_ReducaoZ(Data: string; Hora: string): Integer; StdCall; External 'CONVECF.DLL';

function ECF_LeituraMemoriaFiscalReducaoMFD(cCRZi: string; cCRZf: string; tipo: string): Integer; StdCall; External 'CONVECF.dll';
function ECF_LeituraMemoriaFiscalDataMFD(cDatai: string; cDataf: string; tipo: string): Integer; StdCall; External 'CONVECF.dll';
function ECF_LeituraMemoriaFiscalSerialDataMFD(cDatai: string; cDataf: string; tipo: string): Integer; StdCall; External 'CONVECF.dll';
function ECF_LeituraMemoriaFiscalSerialReducaoMFD(cCRZi: string; cCRZf: string; tipo: string): Integer; StdCall; External 'CONVECF.dll';
function ECF_LeituraMemoriaFiscalData(DataInicial: string; DataFinal: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_LeituraMemoriaFiscalReducao(ReducaoInicial: string; ReducaoFinal: string): Integer; StdCall; External 'CONVECF.DLL';
// Cupom
function ECF_AbreCupom(CGC_CPF: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_AbreCupomMFD(CGC_CPF, Nome, Endereco: string): Integer; StdCall; External 'CONVECF.dll';
function ECF_VendeItemDepartamento(Codigo: string; Descricao: string; Aliquota: string; Quantidade: string; ValorUnitario: string; Acrescimo: string; Desconto: string; IndiceDepto: string; UM: string): Integer; StdCall; External 'CONVECF.dll';
function ECF_CancelaItemGenerico(NumeroItem: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_CancelaCupom: Integer; StdCall; External 'CONVECF.DLL';
function ECF_IniciaFechamentoCupom(AcrescimoDesconto: string; TipoAcrescimoDesconto: string; ValorAcrescimoDesconto: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_EfetuaFormaPagamento(FormaPagamento: string; ValorFormaPagamento: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_TerminaFechamentoCupom(Mensagem: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_FechaCupomResumido(FormaPagamento: string; Mensagem: string): Integer; StdCall; External 'CONVECF.dll';
// Opera��es N�o Fiscal
function ECF_AbreComprovanteNaoFiscalVinculado(FormaPagamento: string; Valor: string; NumeroCupom: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_UsaComprovanteNaoFiscalVinculado(Texto: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_FechaComprovanteNaoFiscalVinculado: Integer; StdCall; External 'CONVECF.DLL';
function ECF_Sangria(Valor: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_Suprimento(Valor: string; FormaPagamento: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_RecebimentoNaoFiscal(IndiceTotalizador: string; Valor: string; FormaPagamento: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_RelatorioGerencial(Texto: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_FechaRelatorioGerencial: Integer; StdCall; External 'CONVECF.DLL';

// Configura��o / Programa��o
function ECF_ProgramaAliquota(Aliquota: string; ICMS_ISS: Integer): Integer; StdCall; External 'CONVECF.DLL';
function ECF_ProgramaHorarioVerao: Integer; StdCall; External 'CONVECF.DLL';
function ECF_NomeiaTotalizadorNaoSujeitoIcms(Indice: Integer; Totalizador: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_ProgramaFormasPagamento(formas: pchar): Integer; StdCall; External 'CONVECF.DLL';
// Outros
function ECF_AcionaGaveta: Integer; StdCall; External 'CONVECF.dll';
function ECF_VerificaEstadoGaveta(var EstadoGaveta: Integer): Integer; StdCall; External 'CONVECF.DLL';
function ECF_ZAUTO(flag: string): Integer; StdCall; External 'CONVECF.DLL';
function ECF_LigaDesligaJanelas(papel: string; outros: string): Integer; StdCall; External 'CONVECF.DLL';

// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //

//=================================================================================================
// EPSON_Serial
//=================================================================================================
function EPSON_Serial_Abrir_Porta(dwVelocidade: Integer; wPorta: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Serial_Abrir_Fechar_Porta_CMD(dwVelocidade: Integer; wPorta: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Serial_Abrir_PortaAD(pszVelocidade: Pchar; pszPorta: Pchar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Serial_Abrir_PortaEx(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Serial_Fechar_Porta(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Serial_Obter_Estado_Com(): Integer; StdCall; External 'InterfaceEpson.dll';
//=================================================================================================
// EPSON_Fiscal
//=================================================================================================
function EPSON_Fiscal_Abrir_Cupom(pszCNPJ: PChar; pszRazaoSocial: PChar; pszEndereco1: PChar; pszEndereco2: PChar; dwPosicao: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Dados_Usuario(pszCGC: PChar; pszSocialReason: PChar; pszAddress1: PChar; pszAddress2: PChar; dwPosition: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Vender_Item(pszCodigo: PChar; pszDescricao: PChar; pszQuantidade: PChar; dwQuantCasasDecimais: Integer; pszUnidade: PChar; pszPrecoUnidade: PChar; dwPrecoCasasDecimais: Integer; pszAliquotas: PChar; dwLinhas: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Obter_SubTotal(pszSubTotal: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Pagamento(pszNumeroPagamento: PChar; pszValorPagamento: PChar; dwCasasDecimais: Integer; pszDescricao1: PChar; pszDescricao2: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Desconto_Acrescimo_Item(pszValor: PChar; dwCasasDecimais: Integer; bDesconto: Boolean; bPercentagem: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Desconto_Acrescimo_Subtotal(pszValor: PChar; dwCasasDecimais: Integer; bDesconto: Boolean; bPercentagem: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Cancelar_Cupom(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Cancelar_Item(pszNumeroItem: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Cancelar_Ultimo_Item(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Cancelar_Desconto_Acrescimo_Item(bDesconto: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Cancelar_Acrescimo_Desconto_Subtotal(bDesconto: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Cancelar_Item_Parcial(pszNumeroItem: PChar; pszQuantidade: PChar; dwQuantCasasDecimais: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Imprimir_Mensagem(pszLinhaTexto1: PChar; pszLinhaTexto2: PChar; pszLinhaTexto3: PChar; pszLinhaTexto4: PChar; pszLinhaTexto5: PChar; pszLinhaTexto6: PChar; pszLinhaTexto7: PChar; pszLinhaTexto8: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Imprimir_MensagemEX(pszText: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Configurar_Codigo_Barras_Mensagem(dwLinha: Integer; dwTipo: Integer; dwAltura: Integer; dwLargura: Integer; dwPosicao: Integer; dwCaracter: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Fechar_CupomEx(pszTotalCupom: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Fechar_Cupom(bCortarPapel: Boolean; bAdicional: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Fiscal_Mensagem_Aplicacao(pszLinha01: PChar; pszLinha02: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
//=================================================================================================
// EPSON_NaoFiscal
//=================================================================================================
function EPSON_NaoFiscal_Abrir_Comprovante(pszCNPJ: PChar; pszRazaoSocial: PChar; pszEndereco1: PChar; pszEndereco2: PChar; dwPosicao: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Vender_Item(pszNumeroOperacao: PChar; pszValorOperacao: PChar; dwCasasDecimais: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Obter_SubTotal(pszSubTotal: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Desconto_Acrescimo_Item(pszValor: PChar; dwCasasDecimais: Integer; bDesconto: Boolean; bPercentagem: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Desconto_Acrescimo_Subtotal(pszValor: PChar; dwCasasDecimais: Integer; bDesconto: Boolean; bPercentagem: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Pagamento(pszNumeroPagamento: PChar; pszValorPagamento: PChar; dwCasasDecimais: Integer; pszDescricao1: PChar; pszDescricao2: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Cancelar_Item(pszItem: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Cancelar_Ultimo_Item(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Cancelar_Desconto_Acrescimo_Item(bDesconto: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Cancelar_Desconto_Acrescimo_Subtotal(bDesconto: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Cancelar_Comprovante(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Fechar_Comprovante(bCortarPapel: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Abrir_CCD(pszNumeroPagamento: PChar; pszValor: PChar; dwCasasDecimais: Integer; pszParcelas: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Abrir_Relatorio_Gerencial(pszNumeroRelatorio: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Imprimir_LinhaEX(pszLinha: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Imprimir_Linha(pszLinha: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Imprimir_15Linhas(pszLinha00: PChar; pszLinha01: PChar; pszLinha02: PChar; pszLinha03: PChar; pszLinha04: PChar; pszLinha05: PChar; pszLinha06: PChar; pszLinha07: PChar; pszLinha08: PChar; pszLinha09: PChar; pszLinha10: PChar; pszLinha11: PChar; pszLinha12: PChar; pszLinha13: PChar; pszLinha014: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Fechar_CCD(bCortarPapel: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Fechar_Relatorio_Gerencial(bCortarPapel: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Cancelar_CCD(pszNumeroPagamento: PChar; pszValor: PChar; dwCasasDecimais: Integer; pszParcelas: PChar; pszNumeroCupom: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Cancelar_Pagamento(pszFormaPagamento: PChar; pszNovaFormaPagamento: PChar; pszValor: PChar; dwCasasDecimais: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Nova_Parcela_CCD(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Nova_Via_CCD(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Reimprimir_CCD(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Sangria(pszValor: PChar; dwCasasDecimais: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Fundo_Troco(pszValor: PChar; dwCasasDecimais: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_NaoFiscal_Imprimir_Codigo_Barras(dwTipo: Integer; dwAltura: Integer; dwLargura: Integer; dwPosicao: Integer; dwCaracter: Integer; pszCodigo: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
//=================================================================================================
// EPSON_RelatorioFiscal
//=================================================================================================
function EPSON_RelatorioFiscal_LeituraX(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_RelatorioFiscal_RZ(pszData: PChar; pszHora: PChar; dwHorarioVerao: Integer; pszCRZ: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_RelatorioFiscal_RZEx(dwHorarioVerao: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_RelatorioFiscal_Leitura_MF(pszInicio: PChar; pszFim: PChar; dwTipoImpressao: Integer; pszBuffer: PChar; pszArquivo: PChar; pdwTamanhoBuffer: PInteger; dwTamBuffer: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_RelatorioFiscal_Salvar_LeituraX(pszArquivo: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_RelatorioFiscal_Abrir_Dia(): Integer; StdCall; External 'InterfaceEpson.dll';
//=================================================================================================
// EPSON_Obter
//=================================================================================================
function EPSON_Obter_Dados_Usuario(pszDadosUsuario: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Tabela_Aliquotas(pszTabelaAliquotas: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Total_Jornada(chOption: PChar; pszZnumber: PChar; pszData: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Tabela_Pagamentos(pszTabelaPagamentos: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Tabela_NaoFiscais(pszTabelaNaoFiscais: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Tabela_Relatorios_Gerenciais(pszTabelaRelatoriosGerenciais: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Total_Cancelado(pszTotalCancelado: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Total_Aliquotas(pszAliquotasTotal: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Total_Bruto(pszVendaBruta: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Total_Descontos(pszTotalDescontos: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Total_Troco(pszTotalTroco: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Total_Acrescimos(pszTotalAcrescimos: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Dados_Impressora(pszDadosImpressora: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Cliche_Usuario(pszDadosUsuario: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Data_Hora_Jornada(pszDataHora: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Numero_ECF_Loja(pszDados: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Hora_Relogio(pszDados: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Simbolo_Moeda(pszDados: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Casas_Decimais(pszDados: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Contadores(pszDados: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Estado_Impressora(pszDados: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_GT(pszDados: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Linhas_Impressas(pszDados: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Linhas_Impressas_RG(pszDados: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Linhas_Impressas_CCD(pszDados: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Linhas_Impressas_Vendas(pszLinhasImpressas: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Linhas_Impressas_Pagamentos(pszLinhasImpressas: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Total_Itens_Vendidos(pszItens: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Estado_Memoria_Fiscal(pszEstado: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Estado_MFD(pszEstado: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Total_Leituras_X_Impressas(pszLeituras: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Dados_Jornada(pszDados: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Caracteres_Linha(pszDados: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Operador(pszDados: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Numero_Ultimo_Item(pszDados: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Informacao_Item(pszNumeroItem: PChar; pszDadosItem: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Estado_Cupom(pszEstado: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Informacao_Ultimo_Documento(pszInfo: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Estado_Corte_Papel(var bHabilitado: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Estado_Horario_Verao(var bEstado: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Venda_Bruta(pszBrutAmount: PChar; pszLastBrutAmount: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Mensagem_Erro(pszCodigoErro: PChar; pszMensagemErro: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Dados_MF_MFD(pszInicio: PChar; pszFinal: PChar; dwTipoEntrada: Integer; dwEspelhos: Integer; dwAtoCotepe: Integer; dwSintegra: Integer; pszArquivoSaida: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Versao_DLL(pszVersao: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Total_JornadaEX(pszOption: Pchar; pszZnumber: PChar; pszData: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Dados_Arquivos_MF_MFD(pszInicio: PChar; pszFim: Pchar; dwTipoEntrada: Integer; dwEspelhos: Integer; dwAtoCOTEPE: Integer; dwSintegra: Integer; pszArquivoSaida: PChar; pszArquivoMF: PChar; pszArquivoMFD: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Separar_AtoCOTEPE(pszFileName: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Salvar_Binario_MF(pszArquivo: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Arquivo_Binario_MFD(pszFileName: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Dados_Ultima_RZ(pszLastRZData: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Obter_Versao_SWBasicoEX(pszVersion: PChar; pszDate: PChar; pszTime: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
//=================================================================================================
// EPSON_Config
//=================================================================================================
function EPSON_Config_Aliquota(pszTaxa: PChar; bTipoISS: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Config_Relatorio_Gerencial(pszReportDescription: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Config_Forma_Pagamento(bVinculado: Boolean; pszNumeroMeio: PChar; pszDescricao: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Config_Totalizador_NaoFiscal(pszDescricao: PChar; var pdwNumeroTotalizador: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Config_Corte_Papel(bHabilitado: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Config_Horario_Verao(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Config_Espaco_Entre_Documentos(pszLinhas: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Config_Espaco_Entre_Linhas(pszEspacos: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Config_Logotipo(pszDados: PChar; dwTamDados: Integer; pszLinha: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Config_Habilita_Logotipo(bHabilita: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Config_Operador(pszDados: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Config_OperadorEX(pszDados: PChar; dwReport: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Config_Serial_Impressora(pszVelocidade: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Config_Dados_Sintegra(pszRazaoSocial: PChar; pszLogradouro: PChar; pszNumero: PChar; pszComplemento: PChar; pszBairro: PChar; pszMunicipio: PChar; pszCEP: PChar; pszUF: PChar; pszFax: PChar; pszFone: PChar; pszNomeContato: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Download_Segmentado_MFD(bHabilita: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Config_Habilita_EAD(bHabilitado: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
//=================================================================================================
// EPSON_Cheque
//=================================================================================================
function EPSON_Cheque_Configurar_Moeda(pszSingular: PChar; pszPlural: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Cheque_Configurar_Parametros1(pszNumeroRegistro: PChar; pszValorX: PChar; pszValorY: PChar; pszDescricao1X: PChar; pszDescricao1Y: PChar; pszDescricao2X: PChar; pszDescricao2Y: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Cheque_Configurar_Parametros2(pszNumeroRegistro: PChar; pszParaX: PChar; pszParaY: PChar; pszCidadeX: PChar; pszCidadeY: PChar; pszOffsetDia: PChar; pszOffsetMes: PChar; pszOffsetAno: PChar; pszAdicionalX: PChar; pszAdicionalY: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Cheque_Imprimir(pszNumeroRegistro: PChar; pszValor: PChar; dwCasasDecimais: Integer; ByValpszPara: PChar; pszCidade: PChar; pszDados: PChar; pszTexto: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Cheque_ImprimirEX(pszNumeroRegistro: PChar; pszValor: PChar; dwCasasDecimais: Integer; pszPara: PChar; pszCidade: PChar; pszDados: PChar; pszTexto: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Cheque_Preparar_Endosso(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Endosso_Estacao_Cheque(pszToX: PChar; pszToY: PChar; dwHorizontal: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Cheque_Imprimir_Endosso(pszLinhaTexto: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Cheque_Ejetar_Endosso(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Cheque_Cancelar_Impressao(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Endosso_Estacao_ChequeEX(pszToX: PChar; pszToY: PChar; dwHorizontal: Integer; pszText: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Cheque_Ler_MICR(pszMICR: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
//=================================================================================================
// EPSON_Impressora
//=================================================================================================
function EPSON_Impressora_Abrir_Gaveta(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Impressora_Avancar_Papel(dwLines: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Impressora_Cortar_Papel(): Integer; StdCall; External 'InterfaceEpson.dll';
//=================================================================================================
// EPSON_Autenticar
//=================================================================================================
function EPSON_Autenticar_Imprimir(pszMensagem: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Autenticar_Reimprimir(): Integer; StdCall; External 'InterfaceEpson.dll';
//=================================================================================================
// EPSON_Sys
//=================================================================================================
function EPSON_Sys_Informar_Handle_Janela(HWNDHandle: THandle): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Sys_Atualizar_Janela(): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Sys_Aguardar_Arquivo(pszArquivo: PChar; dwTimeout: Integer; bBloqueiaEntradas: Boolean; bSincrono: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Sys_Bloquear_Entradas(bBloqueiaEntradas: Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Sys_Log(pszPath: PChar; dwAction: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
//=================================================================================================
// EPSON_Display
//=================================================================================================
function EPSON_Display_Enviar_Texto(pszTexto: PChar): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Display_Set_Cursor(dwAcao: Integer; dwColuna: Integer; dwLinha: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Display_Apagar_Texto(dwLinha: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Display_Configurar(dwBrilho: Integer; dwLampejo: Integer; dwRolagem: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
function EPSON_Display_Inicializar(dwAcao: Integer): Integer; StdCall; External 'InterfaceEpson.dll';
//=================================================================================================
// Fun��es diversas
function FormatarValor(peValor: Currency; piDecimais: Integer; pbRemovePonto: Boolean = True): string;
function EPSON_CupomNaoFiscalAberto: Boolean;
function EPSON_CupomFiscalAberto: Boolean;
function EPSON_ECFLigada: string;
function EPSON_NumeroSerie: string;
function EPSON_NumeroCaixa: string;
function EPSON_VersaoSoftwareBasico: string;
function EPSON_DataHoraSoftwareBasico: string;
function EPSON_GavetaAberta: Boolean;

// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //

implementation

uses funcoes, Constantes, Modulo, Principal, UFuncoes;


// -------------------------------------------------------------------------- //

function FormatarValor(peValor: Currency; piDecimais: Integer; pbRemovePonto: Boolean = True): string;
var
  I: Integer;
  sDecimais: string;

begin
  sDecimais := '';
  for I := 1 to piDecimais do
  begin
    sDecimais := sDecimais + '0';
  end;

  Result := FormatFloat('########0.' + sDecimais, peValor);

  if (sDecimais = '') or pbRemovePonto then
  begin
    if Pos(DecimalSeparator, Result) > 0 then
      Delete(Result, Pos(DecimalSeparator, Result), 1);
  end;
end;

// -------------------------------------------------------------------------- //

function Executa_programa(const FileName, Params: string;
  const
  WindowState: Word): boolean;

var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: string;

begin
  { Coloca o nome do arquivo entre aspas. Isto � necess�rio devido aos espa�os contidos em nomes longos }
  CmdLine := '"' + Filename + '"' + Params;
  FillChar(SUInfo, SizeOf(SUInfo), #0);

  with SUInfo do
  begin
    cb := SizeOf(SUInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WindowState;
  end;

  Result := CreateProcess(nil, PChar(CmdLine), nil, nil, false,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
    PChar(ExtractFilePath(Filename)), SUInfo, ProcInfo);

  { Aguarda at� ser finalizado }
  if Result then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);

    { Libera os Handles }
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

// -------------------------------------------------------------------------- //
// Retorno de Comunicacao com ECF

function cECF_Analisa_Retorno(COD_ECF: Integer): string;
begin
  if COD_ECF = BEMATECH then
  begin
    Result := OK;
    if iRetorno = 0 then Result := 'Erro de Comunica��o!';
    if iRetorno = -1 then Result := 'Erro de Execu��o na Fun��o. Verifique!';
    if iRetorno = -2 then Result := 'Par�metro Inv�lido!';
    if iRetorno = -3 then Result := 'Al�quota n�o programada!';
    if iRetorno = -4 then Result := 'Arquivo BemaFI32.INI n�o encontrado. Verifique!';
    if iRetorno = -5 then Result := 'Erro ao Abrir a Porta de Comunica��o!';
    if iRetorno = -6 then Result := 'Impressora Desligada ou Desconectada!';
    if iRetorno = -7 then Result := 'Banco N�o Cadastrado no Arquivo BemaFI32.ini!';
    if iRetorno = -8 then Result := 'Erro ao Criar ou Gravar no Arquivo Retorno.txt ou Status.txt!';
    if iRetorno = -18 then Result := 'N�o foi poss�vel abrir arquivo INTPOS.001';
    if iRetorno = -19 then Result := 'Par�metro diferentes!';
    if iRetorno = -20 then Result := 'Transa��o cancelada pelo Operador!';
    if iRetorno = -21 then Result := 'A Transa��o n�o foi aprovada!';
    if iRetorno = -22 then Result := 'N�o foi poss�vel terminar a Impress�o!';
    if iRetorno = -23 then Result := 'N�o foi poss�vel terminar a Opera��o!';
    if iRetorno = -24 then Result := 'Forma de pagamento n�o programada.';
    if iRetorno = -25 then Result := 'Totalizador n�o fiscal n�o programado.';
    if iRetorno = -26 then Result := 'Transa��o j� Efetuada!';
    if iRetorno = -28 then Result := 'N�o h� Informa��es para serem Impressas!';
  end
  else
    if COD_ECF = DARUMA then
    begin
      if iRetorno = 1 then
        Result := OK
      else
        Result := 'Erro de Comunica��o!';
    end
    else
      if COD_ECF = SWEDA then
      begin
        Result := OK;
        if iRetorno = 0 then Result := 'Erro de Comunica��o!';
        if iRetorno = -1 then Result := 'Erro de Execu��o na Fun��o. Verifique!';
        if iRetorno = -2 then Result := 'Par�metro Inv�lido!';
        if iRetorno = -3 then Result := 'Al�quota n�o programada!';
        if iRetorno = -4 then Result := 'Arquivo INI n�o encontrado. Verifique!';
        if iRetorno = -5 then Result := 'Erro ao Abrir a Porta de Comunica��o!';
        if iRetorno = -6 then Result := 'Impressora Desligada ou Desconectada!';
        if iRetorno = -7 then Result := 'Banco N�o Cadastrado no Arquivo BemaFI32.ini!';
        if iRetorno = -8 then Result := 'Erro ao Criar ou Gravar no Arquivo Retorno.txt ou Status.txt!';
        if iRetorno = -18 then Result := 'N�o foi poss�vel abrir arquivo INTPOS.001';
        if iRetorno = -19 then Result := 'Par�metro diferentes!';
        if iRetorno = -20 then Result := 'Transa��o cancelada pelo Operador!';
        if iRetorno = -21 then Result := 'A Transa��o n�o foi aprovada!';
        if iRetorno = -22 then Result := 'N�o foi poss�vel terminal a Impress�o!';
        if iRetorno = -23 then Result := 'N�o foi poss�vel terminal a Opera��o!';
        if iRetorno = -24 then Result := 'Forma de pagamento n�o programada.';
        if iRetorno = -25 then Result := 'Totalizador n�o fiscal n�o programado.';
        if iRetorno = -26 then Result := 'Transa��o j� Efetuada!';
        if iRetorno = -28 then Result := 'N�o h� Informa��es para serem Impressas!';
      end
      else
        if COD_ECF = EPSON then
        begin
          if iRetorno = 0 then
            Result := OK
          else
            Result := cECF_Retorno_Impressora(COD_ECF);
        end
        else
          if COD_ECF = 5 then
          begin
            if iRetorno < 0 then
              Result := 'Erro de Comunica��o!'
            else
              Result := OK;
          end;
end;


// -------------------------------------------------------------------------- //
// Retorno de tratamento do comando

function cECF_Retorno_Impressora(COD_ECF: Integer): string;
var
  Mensagem: string;
  sErro: string;
  ST1err, ST1field, ST2, ST3, ST4, ST5, Temp: string;
  iST3, iST4, iST5, iConta: Integer;
  flagB15, flagB14, flagB12, flagB11, flagB10, flagB09, flagB07: Boolean;
  sMensagemErro: string;
  iPos: Integer;

begin
  if COD_ECF = BEMATECH then
  begin
    iACK := 0; iST1 := 0; iST2 := 0;
    iRetorno := Bematech_FI_RetornoImpressora(iACK, iST1, iST2);
    Mensagem := '';
    if iACK = 21 then Result := 'A Impressora retornou NAK. O programa ser� abortado!';
    if iACK = 6 then
    begin
      // Verifica ST1
      if iST1 >= 128 then begin iST1 := iST1 - 128; Mensagem := Mensagem + ' ' + 'Fim do Papel!' end;
      if iST1 >= 64 then begin iST1 := iST1 - 64; end;
      if iST1 >= 32 then begin iST1 := iST1 - 32; Mensagem := Mensagem + ' ' + 'Erro no rel�gio!' end;
      if iST1 >= 16 then begin iST1 := iST1 - 16; Mensagem := Mensagem + ' ' + 'Impressora em ERRO!' end;
      if iST1 >= 8 then begin iST1 := iST1 - 8; Mensagem := Mensagem + ' ' + 'CMD n�o iniciado com ESC!' end;
      if iST1 >= 4 then begin iST1 := iST1 - 4; Mensagem := Mensagem + ' ' + 'Comando Inexistente!' end;
      if iST1 >= 2 then begin iST1 := iST1 - 2; Mensagem := Mensagem + ' ' + 'Cupom Aberto' end;
      if iST1 >= 1 then begin iST1 := iST1 - 1; Mensagem := Mensagem + ' ' + 'N� de Par�metros Inv�lidos!' end;

      // Verifica ST2
      if iST2 >= 128 then begin iST2 := iST2 - 128; Mensagem := Mensagem + ' ' + 'Tipo de Par�metro Inv�lido!' end;
      if iST2 >= 64 then begin iST2 := iST2 - 64; Mensagem := Mensagem + ' ' + 'Mem�ria Fiscal Lotada.' end;
      if iST2 >= 32 then begin iST2 := iST2 - 32; Mensagem := Mensagem + ' ' + 'CMOS n�o Vol�til!' end;
      if iST2 >= 16 then begin iST2 := iST2 - 16; Mensagem := Mensagem + ' ' + 'Al�quota N�o Programada.' end;
      if iST2 >= 8 then begin iST2 := iST2 - 8; Mensagem := Mensagem + ' ' + 'Al�quotas lotadas.' end;
      if iST2 >= 4 then begin iST2 := iST2 - 4; Mensagem := Mensagem + ' ' + 'Cancelamento n�o Permitido.' end;
      if iST2 >= 2 then begin iST2 := iST2 - 2; Mensagem := Mensagem + ' ' + 'CGC/IE n�o Programados.' end;
      if iST2 >= 1 then begin iST2 := iST2 - 1; Mensagem := Mensagem + ' ' + 'Comando n�o Executado.' end;
    end;
    if Mensagem = '' then
      Result := OK
    else
      Result := Mensagem;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iACK := 0; iST1 := 0; iST2 := 0;
      IRetorno := Daruma_FI_RetornoImpressora(iACK, iST1, iST2);
      SetLength(sErro, 4);
      IRetorno := Daruma_FI_RetornaErroExtendido(sErro);

      sErro := TrimLeft(TrimRight(serro));

      Mensagem := '';
      if sErro = '00' then Mensagem := 'IF em modo Manuten��o. Foi ligada sem o Jumper de Opera��o.';
      if sErro = '01' then Mensagem := 'M�todo dispon�vel somente em modo Manuten��o.';
      if sErro = '02' then Mensagem := 'Erro durante a grava��o da Mem�ria Fiscal.';
      if sErro = '03' then Mensagem := 'Mem�ria Fiscal esgotada.';
      if sErro = '04' then Mensagem := 'Erro no rel�gio interno da IF.';
      if sErro = '05' then Mensagem := 'Falha mec�nica na IF.';
      if sErro = '06' then Mensagem := 'Erro durante a leitura da Mem�ria Fiscal.';
      if sErro = '07' then Mensagem := 'Metodo permitido apenas em modo fiscal (IF sem jmper).';
      if sErro = '10' then Mensagem := 'Documento sendo emitido.';
      if sErro = '11' then Mensagem := 'Documento n�o foi aberto.';
      if sErro = '12' then Mensagem := 'N�o existe documento a cancelar.';
      if sErro = '13' then Mensagem := 'D�gito n�o num�rico n�o esperado, foi encontrado nos Par�metros do M�todo.';
      if sErro = '14' then Mensagem := 'N�o h� mais mem�ria dispon�vel para esta opera��o.';
      if sErro = '15' then Mensagem := 'Item a cancelar n�o foi encontrado.';
      if sErro = '16' then Mensagem := 'Erro de sintaxe no m�todo.';
      if sErro = '17' then Mensagem := '"Estouro" de capacidade num�rica (overflow).';
      if sErro = '18' then Mensagem := 'Selecionado totalizador tributado com al�quota de imposto n�o definida.';
      if sErro = '19' then Mensagem := 'Mem�ria Fiscal vazia.';
      if sErro = '20' then Mensagem := 'N�o existem campos que requerem atualiza��o.';
//   if sErro = '21' then Mensagem :=  'Detectado proximidade do final da bobina de papel';
      if sErro = '22' then Mensagem := 'Cupom de Redu��o Z j� foi emitido. IF inoperante at� 0:00h do pr�ximo dia.';
      if sErro = '23' then Mensagem := 'Redu��o Z do per�odo anterior ainda pendente. IF inoperante.';
      if sErro = '24' then Mensagem := 'Valor de desconto ou acr�scimo inv�lido (limitado a 100%).';
      if sErro = '25' then Mensagem := 'Car�ctere inv�lido foi encontrado nos Par�metros do M�todos.';
      if sErro = '26' then Mensagem := 'M�doto n�o pode ser executado.';
      if sErro = '27' then Mensagem := 'Nenhum perif�rico conectado a interface auxiliar.';
      if sErro = '28' then Mensagem := 'Foi encontrado um campo em zero.';
      if sErro = '29' then Mensagem := 'Documento anterior n�o foi Cupom Fiscal. N�o pode emitir Cupom Adicional.';
      if sErro = '30' then Mensagem := 'Acumulador N�o Fiscal selecionado n�o � v�lido ou n�o est� dispon�vel.';
      if sErro = '31' then Mensagem := 'N�o pode autenticar. Excedeu 4 repeti��es ou n�o � permitida nesta fase.';
      if sErro = '32' then Mensagem := 'Cupom adicional inibido por configura��o.';
      if sErro = '35' then Mensagem := 'Rel�gio Interno Inoperante.';
      if sErro = '36' then Mensagem := 'Vers�o do firmware gravada na Mem�ria Fiscal n�o � a esperada.';
      if sErro = '37' then Mensagem := 'Al�quota de imposto informada j� est� carregada na mem�ria.';
      if sErro = '38' then Mensagem := 'Forma de pagamento selecionada n�o � v�lida.';
      if sErro = '39' then Mensagem := 'Erro na seq��ncia de fechamento do Cupom Fiscal.';
      if sErro = '40' then Mensagem := 'IF em Jornada Fiscal. Altera��o da configura��o n�o � permitida.';
      if sErro = '41' then Mensagem := 'Data inv�lida. Data fornecida � inferior � �ltima gravada na Mem�ria Fiscal.';
      if sErro = '42' then Mensagem := 'Leitura X inicial ainda n�o foi emitida.';
      if sErro = '43' then Mensagem := 'N�o pode emitir Comprovante Vinculado.';
      if sErro = '44' then Mensagem := 'Cupom de Or�amento n�o permitido para este estabelecimento.';
      if sErro = '45' then Mensagem := 'Campo obrigat�rio em branco.';
      if sErro = '48' then Mensagem := 'N�o pode estornar.';
      if sErro = '49' then Mensagem := 'Forma de pagamento indicada n�o encontrada.';
      if sErro = '50' then Mensagem := 'Fim da bobina de papel.';
      if sErro = '51' then Mensagem := 'Nenhum usu�rio cadastrado na MF.';
      if sErro = '52' then Mensagem := 'MF n�o instalada ou n�o inicializada.';
      if sErro = '56' then Mensagem := 'Documento j� aberto.';
      if sErro = '61' then Mensagem := 'Queda de energia durante a emiss�o de Cupom Fiscal.';
      if sErro = '76' then Mensagem := 'Desconto em ISS n�o permitido neste ECF (a programa��o dever� ser feita por meio de interven��o t�cnica e caso o Estado permita).';
      if sErro = '75' then Mensagem := 'Opera��o com ISS n�o permitida (se a sua impressora for uma FS600 ou FS2100T, ent�o ser� preciso ter uma inscri��o municipal gravada em sua impressora para que seja poss�vel programar/utilizar al�quota de servi�o).';
      if sErro = '77' then Mensagem := 'Acr�scimo em IOF inibido.';
      if sErro = '80' then Mensagem := 'Perif�rico na interface auxiliar n�o pode ser reconhecido.';
      if sErro = '81' then Mensagem := 'Solicitado preenchimento de cheque de banco desconhecido.';
      if sErro = '82' then Mensagem := 'Solicitado transmiss�o de mensagem nula pela interface auxiliar.';
      if sErro = '83' then Mensagem := 'Extenso do cheque n�o cabe no espa�o dispon�vel.';
      if sErro = '84' then Mensagem := 'Erro na comunica��o com a interface auxiliar.';
      if sErro = '85' then Mensagem := 'Erro no d�gito verificador durante comunica��o com a PertoCheck.';
      if sErro = '86' then Mensagem := 'Falha na carga de geometria de folha de cheque.';
      if sErro = '87' then Mensagem := 'Par�metros do M�todo: inv�llido para o campo de data do cheque.';
      if sErro = '90' then Mensagem := 'Sequ�ncia de valida��o de n�mero de s�rie inv�lida.';
      if sErro = '180' then Mensagem := 'Mensagem do aplicativo n�o programada. (Esta mensagem n�o � opcional e sim uma exig�ncia da legisla��o e dever� ser programada para que o ECF seja liberado para a emiss�o de documentos fiscais.';
      if sErro = '181' then Mensagem := 'N�o � possivel realizar Redu��o Z entre 00:00am e 02:00am (Meia Noite e Duas da Manh�) nesta vers�o de firmware da FS600 (est� limita��o existe nas vers�es 1.1 pra baixo.';
      if sErro = '999' then Mensagem := 'Impressora Fiscal n�o responde. Verifique se est� ligada ou o cabo est� conectado corretamente.';

      if Mensagem = '' then
        Result := OK
      else
        Result := Mensagem;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iACK := 0; iST1 := 0; iST2 := 0;
        iRetorno := ECF_RetornoImpressora(iACK, iST1, iST2);
        Mensagem := '';
        if iACK = 21 then Result := 'A Impressora retornou NAK. O programa ser� abortado!';
        if iACK = 6 then
        begin
      // Verifica ST1
          if iST1 >= 128 then begin iST1 := iST1 - 128; Mensagem := Mensagem + ' ' + 'Fim do Papel!' end;
          if iST1 >= 64 then begin iST1 := iST1 - 64; end;
          if iST1 >= 32 then begin iST1 := iST1 - 32; Mensagem := Mensagem + ' ' + 'Erro no rel�gio!' end;
          if iST1 >= 16 then begin iST1 := iST1 - 16; Mensagem := Mensagem + ' ' + 'Impressora em ERRO!' end;
          if iST1 >= 8 then begin iST1 := iST1 - 8; Mensagem := Mensagem + ' ' + 'CMD n�o iniciado com ESC!' end;
          if iST1 >= 4 then begin iST1 := iST1 - 4; Mensagem := Mensagem + ' ' + 'Comando Inexistente!' end;
          if iST1 >= 2 then begin iST1 := iST1 - 2; Mensagem := Mensagem + ' ' + 'Cupom Aberto' end;
          if iST1 >= 1 then begin iST1 := iST1 - 1; Mensagem := Mensagem + ' ' + 'N� de Par�metros Inv�lidos!' end;

      // Verifica ST2
          if iST2 >= 128 then begin iST2 := iST2 - 128; Mensagem := Mensagem + ' ' + 'Tipo de Par�metro Inv�lido!' end;
          if iST2 >= 64 then begin iST2 := iST2 - 64; Mensagem := Mensagem + ' ' + 'Mem�ria Fiscal Lotada.' end;
          if iST2 >= 32 then begin iST2 := iST2 - 32; Mensagem := Mensagem + ' ' + 'CMOS n�o Vol�til!' end;
          if iST2 >= 16 then begin iST2 := iST2 - 16; Mensagem := Mensagem + ' ' + 'Al�quota N�o Programada.' end;
          if iST2 >= 8 then begin iST2 := iST2 - 8; Mensagem := Mensagem + ' ' + 'Al�quotas lotadas.' end;
          if iST2 >= 4 then begin iST2 := iST2 - 4; Mensagem := Mensagem + ' ' + 'Cancelamento n�o Permitido.' end;
          if iST2 >= 2 then begin iST2 := iST2 - 2; Mensagem := Mensagem + ' ' + 'CGC/IE n�o Programados.' end;
          if iST2 >= 1 then begin iST2 := iST2 - 1; Mensagem := Mensagem + ' ' + 'Comando n�o Executado.' end;
        end;
        if Mensagem = '' then
          Result := OK
        else
          Result := Mensagem;
      end
      else
        if COD_ECF = EPSON then
        begin
          Mensagem := '';
          Result := OK;

          for iConta := 1 to 2 do
            ST1err := ST1err + ' ';

          for iConta := 1 to 2 do
            ST1field := ST1field + ' ';

          for iConta := 1 to 4 do
            ST2 := ST2 + ' ';

          for iConta := 1 to 4 do
            ST3 := ST3 + ' ';

          for iConta := 1 to 4 do
            ST4 := ST4 + ' ';

          for iConta := 1 to 4 do
            ST5 := ST5 + ' ';

          for iConta := 1 to 20 do
            Temp := Temp + ' ';

          iRetorno := EPSON_Obter_Estado_Impressora(PChar(Temp));

          if iRetorno <> 0 then
            Result := ERRO
          else
          begin
            if iRetorno <> 0 then
              Result := ERRO
            else
              Result := OK;

            ST1err := Copy(Temp, 1, 2);
            ST1field := Copy(Temp, 3, 2);
            ST2 := Copy(Temp, 5, 4);
            ST3 := Copy(Temp, 9, 4);
            ST4 := Copy(Temp, 13, 4);
            ST5 := Copy(Temp, 17, 4);

      //==============================================================================
      //Par�metros do �ltimo comando
      //==============================================================================
            case StrToInt(ST1err) of
              0: Mensagem := Mensagem + '';
              1: Mensagem := Mensagem + 'Campo deve ser um ponteiro para string.';
              2: Mensagem := Mensagem + 'String com data inv�lida.';
              3: Mensagem := Mensagem + 'String com hora inv�lida.';
              4: Mensagem := Mensagem + 'String n�o est� vazia ou cont�m data inv�lida.';
              5: Mensagem := Mensagem + 'String n�o est� vazia ou cont�m hora inv�lida.';
              6: Mensagem := Mensagem + 'String n�o pode ser vazia.';
            else
        // Mensagem := Mensagem + 'Erro n�o mapeado.';
            end;

      //==============================================================================
      //Estado da Comunica��o
      //==============================================================================
            case StrToInt('$' + ST2) of
              0: Mensagem := Mensagem + '';
              1: Mensagem := Mensagem + 'Porta j� est� aberta.';
              2: Mensagem := Mensagem + 'Porta usada por outra aplica��o.';
              4: Mensagem := Mensagem + 'N�mero de porta inv�lido.';
              5: Mensagem := Mensagem + 'Velocidade inv�lida.';
              16: Mensagem := Mensagem + 'String n�o est� vazia ou cont�m hora inv�lida.';
            else
              Mensagem := Mensagem + 'Erro interno da biblioteca.';
            end;

      //==============================================================================
      //Estado da Impressora
      //==============================================================================
            flagB09 := false;
            flagB10 := false;
            iST3 := StrToInt('$' + ST3);
      //****************************************************************************
      //                       TRATAMENTO DO BIT 15                                *
      //****************************************************************************
            if (iST3 >= 32768) then
            begin
              Mensagem := Mensagem + 'Impressora Desligada.';
              iST3 := iST3 - 32768;
            end;

      //****************************************************************************
      //                       TRATAMENTO DO BIT 14                                *
      //****************************************************************************
            if (iST3 >= 16384) then
            begin
              Mensagem := Mensagem + 'Erro de impress�o.';
              iST3 := iST3 - 16384;
            end;

      //****************************************************************************
      //                       TRATAMENTO DO BIT 13                                *
      //****************************************************************************
            if (iST3 >= 8192) then
            begin
              Mensagem := Mensagem + 'Tampa superior aberta.';
              iST3 := iST3 - 8192;
            end;

      //****************************************************************************
      //                       TRATAMENTO DO BIT 12                                *
      //****************************************************************************
            if (iST3 >= 4096) then
            begin
              Mensagem := Mensagem + 'Gaveta Aberta.';
              iST3 := iST3 - 4096;
            end;

      //****************************************************************************
      //                       TRATAMENTO DOS BITS 10 E 9                          *
      //****************************************************************************
            if (iST3 >= 1024) then
            begin
              flagB10 := true;
              iST3 := iST3 - 1024;
            end;

            if (iST3 >= 512) then
            begin
              flagB09 := true;
              iST3 := iST3 - 512;
            end;

      //****************************************************************************
      //                       TRATAMENTO DO BIT 8                                 *
      //****************************************************************************
            if (iST3 >= 256) then
            begin
          // Mensagem := Mensagem + 'Aguardando retirada do papel.';
              iST3 := iST3 - 256;
            end;

      //****************************************************************************
      //                       TRATAMENTO DO BIT 7                                 *
      //****************************************************************************
            if (iST3 >= 128) then
            begin
              Mensagem := Mensagem + 'Aguardando inser��o do papel.';
              iST3 := iST3 - 128;
            end;

      //****************************************************************************
      //                       TRATAMENTO DO BIT 6                                 *
      //****************************************************************************
            if (iST3 >= 64) then
            begin
          // T4.Text := T4.Text + 'Estado do sensor inferior da esta��o de cheque = 1 - ';
              iST3 := iST3 - 64;
            end;

      //****************************************************************************
      //                       TRATAMENTO DO BIT 5                                 *
      //****************************************************************************
            if (iST3 >= 32) then
            begin
          // T4.Text := T4.Text + 'Estado do sensor superior da esta��o do cheque = 1 - ';
              iST3 := iST3 - 32;
            end;

      //****************************************************************************
      //                       TRATAMENTO DO BIT 4                                 *
      //****************************************************************************
            if (iST3 >= 16) then
            begin
          // T4.Text := T4.Text + 'Estado do sensor de autentica��o = 1 - ';
              iST3 := iST3 - 16;
            end;

      //****************************************************************************
      //                       TRATAMENTO DO BIT 3                                 *
      //****************************************************************************
            if (iST3 >= 8) then
            begin
              Mensagem := Mensagem + 'Impressora sem papel.';
              iST3 := iST3 - 8;
            end;

      //****************************************************************************
      //                       TRATAMENTO DO BIT 2                                 *
      //****************************************************************************
            if (iST3 >= 4) then
            begin
          // T4.Text := T4.Text + 'Pouco papel - ';
              iST3 := iST3 - 4;
            end;

      //****************************************************************************
      //                       TRATAMENTO DO BIT 1                                 *
      //****************************************************************************
            if (iST3 >= 2) then
            begin
              Mensagem := Mensagem + 'Impressora sem papel.';
              iST3 := iST3 - 2;
            end;

      //****************************************************************************
      //                       TRATAMENTO DO BIT 0                                 *
      //****************************************************************************
            if (iST3 >= 1) then
            begin
          // T4.Text := T4.Text + 'Pouco papel - ';
            end;

      //==============================================================================
      //Estado fiscal
      //==============================================================================
            flagB15 := false;
            flagB14 := false;
            flagB11 := false;
            flagB10 := false;

            iST4 := StrToInt('$' + ST4);

      //****************************************************************************
      //                       TRATAMENTO DOS BITS 15 E 14                         *
      //****************************************************************************
            if (iST4 >= 32768) then
            begin
              flagB15 := true;
              iST4 := iST4 - 32768;
            end;

            if (iST4 >= 16384) then
            begin
              flagB14 := true;
              iST4 := iST4 - 16384;
            end;

      {
      If ((flagB15 = True) And (flagB14 = True)) Then
        T5.Text := T5.Text + 'Modo Fiscalizado - '
      Else If ((flagB15 = True) And (flagB14 = False)) Then
        T5.Text := T5.Text + 'Modo manufatura (N�o-Fiscalizado) - '
      Else If ((flagB15 = False) And (flagB14 = False)) Then
          T5.Text := T5.Text + 'Modo bloqueado - ';


      //****************************************************************************

      //****************************************************************************
      //                           TRATAMENTO DO BITS 12                           *
      //****************************************************************************
      If (iST4 >= 4096) Then
        begin
          T5.Text := T5.Text + 'Modo de Interven��o T�cnica - ';
          iST4 := iST4 - 4096;
        END
      Else
        T5.Text := T5.Text + 'Modo de opera��o normal - ';
      //****************************************************************************
      }

      //****************************************************************************
      //                       TRATAMENTO DOS BITS 11 E 10                         *
      //****************************************************************************
            if (iST4 >= 2048) then
            begin
              flagB11 := true;
              iST4 := iST4 - 2048;
            end;

            if (iST4 >= 1024) then
            begin
              flagB10 := true;
              iST4 := iST4 - 1024;
            end;

            if ((flagB11 = True) and (flagB10 = True)) then
              Mensagem := Mensagem + 'Erro de leitura/escrita da Mem�ria Fiscal.'
            else if ((flagB11 = True) and (flagB10 = False)) then
              Mensagem := Mensagem + 'Mem�ria Fiscal cheia.'
            else if ((flagB11 = False) and (flagB10 = True)) then
              Mensagem := Mensagem + 'Mem�ria Fiscal em esgotamento.';

      //****************************************************************************

      //****************************************************************************
      //                           TRATAMENTO DO BIT7                              *
      //****************************************************************************
            if (iST4 >= 128) then
            begin
          // Mensagem := Mensagem + 'Per�odo de vendas aberto.';
              iST4 := iST4 - 128;
            end
            else
              Mensagem := Mensagem + 'Per�odo de vendas fechado.';

      //****************************************************************************

      //****************************************************************************
      //                       TRATAMENTO DOS BITS 3,2,1 E 0                       *
      //****************************************************************************
      {If iST4 = 9 Then
        Mensagem := Mensagem + 'Cheque ou autentica��o (TMH6000 e TMU675).'
      Else If iST4 = 8 Then
        T5.Text := T5.Text + 'Comprovante N�o-Fiscal - '
      Else If iST4 = 4 Then
        T5.Text := T5.Text + 'Relat�rio Gerencial - '
      Else If iST4 = 3 Then
        T5.Text := T5.Text + 'Estorno de Comprovante de Cr�dito ou D�bito - '
      Else If iST4 = 2 Then
        T5.Text := T5.Text + 'Comprovante de Cr�dito ou D�bito - '
      Else If iST4 = 1 Then
        T5.Text := T5.Text + 'Cupom Fiscal aberto - '
      Else If iST4 = 0 Then
        T5.Text := T5.Text + 'Documento fechado - '; }

      //****************************************************************************

      //==============================================================================
      //Estado de execu��o do �ltimo comando
      //==============================================================================
            ST5 := UpperCase(ST5);
            iST5 := StrToInt('$' + ST5);
            case iST5 of
              $0000: Mensagem := Mensagem + 'Resultado sem erro.';
              $0001: Mensagem := Mensagem + 'Erro interno.';
              $0002: Mensagem := Mensagem + 'Erro de inicia��o do equipamento.';
              $0003: Mensagem := Mensagem + 'Erro de processo interno.';
              $0101: Mensagem := Mensagem + 'Comando inv�lido para o estado atual.';
              $0102: Mensagem := Mensagem + 'Comando inv�lido para o documento atual.';
              $0106: Mensagem := Mensagem + 'Comando aceito apenas fora de interven��o.';
              $0107: Mensagem := Mensagem + 'Comando aceito apenas dentro de interven��o.';
              $0108: Mensagem := Mensagem + 'Comando inv�lido durante processo de scan.';
              $0109: Mensagem := Mensagem + 'Excesso de interven��es.';
              $0201: Mensagem := Mensagem + 'Comando com frame inv�lido.';
              $0202: Mensagem := Mensagem + 'Comando inv�lido.';
              $0203: Mensagem := Mensagem + 'Campos em excesso.';
              $0204: Mensagem := Mensagem + 'Campos em falta.';
              $0205: Mensagem := Mensagem + 'Campo n�o opcional.';
              $0206: Mensagem := Mensagem + 'Campo alfanum�rico inv�lido.';
              $0207: Mensagem := Mensagem + 'Campo alfab�tico inv�lido.';
              $0208: Mensagem := Mensagem + 'Campo num�rico inv�lido.';
              $0209: Mensagem := Mensagem + 'Campo bin�rio inv�lido.';
              $020A: Mensagem := Mensagem + 'Campo imprim�vel inv�lido.';
              $020B: Mensagem := Mensagem + 'Campo hexadecimal inv�lido.';
              $020C: Mensagem := Mensagem + 'Campo data inv�lido.';
              $020D: Mensagem := Mensagem + 'Campo hora inv�lido.';
              $020E: Mensagem := Mensagem + 'Campo com atributos de impress�o inv�lidos.';
              $020F: Mensagem := Mensagem + 'Campo booleano inv�lido.';
              $0210: Mensagem := Mensagem + 'Campo com tamanho inv�lido.';
              $0211: Mensagem := Mensagem + 'Extens�o de comando inv�lida.';
              $0212: Mensagem := Mensagem + 'C�digo de barra n�o permitido.';
              $0213: Mensagem := Mensagem + 'Atributos de impress�o n�o permitidos.';
              $0214: Mensagem := Mensagem + 'Atributos de impress�o inv�lidos.';
              $0215: Mensagem := Mensagem + 'C�digo de barras incorretamente definido.';
              $0217: Mensagem := Mensagem + 'Comando invalido para a porta selecionada.';
              $0301: Mensagem := Mensagem + 'Erro de hardware.';
              $0302: Mensagem := Mensagem + 'Impressora n�o est� pronta.';
              $0303: Mensagem := Mensagem + 'Erro de Impress�o.';
              $0304: Mensagem := Mensagem + 'Falta de papel.';
              $0305: Mensagem := Mensagem + 'Pouco papel dispon�vel.';
              $0306: Mensagem := Mensagem + 'Erro em carga ou expuls�o do papel.';
              $0307: Mensagem := Mensagem + 'Caracter�stica n�o suportada pela impressora.';
              $0308: Mensagem := Mensagem + 'Erro de display.';
              $0309: Mensagem := Mensagem + 'Seq��ncia de scan inv�lida.';
              $300A: Mensagem := Mensagem + 'N�mero de �rea de recorte inv�lido.';
              $300B: Mensagem := Mensagem + 'Scanner n�o preparado.';
              $300C: Mensagem := Mensagem + 'Qualidade de Logotipo n�o suportada pela impressora.';
              $030E: Mensagem := Mensagem + 'Erro de leitura do microc�digo.';
              $0401: Mensagem := Mensagem + 'N�mero de s�rie inv�lido.';
              $0402: Mensagem := Mensagem + 'Requer dados de fiscaliza��o j� configurados.';
              $0501: Mensagem := Mensagem + 'Data / Hora n�o configurada.';
              $0502: Mensagem := Mensagem + 'Data inv�lida.';
              $0503: Mensagem := Mensagem + 'Data em intervalo inv�lido.';
              $0504: Mensagem := Mensagem + 'Nome operador inv�lido.';
              $0505: Mensagem := Mensagem + 'N�mero de caixa inv�lido.';
              $0508: Mensagem := Mensagem + 'Dados de Cabe�alho ou rodap� inv�lidos.';
              $0509: Mensagem := Mensagem + 'Excesso de fiscaliza��o.';
              $500C: Mensagem := Mensagem + 'N�mero m�ximo de meios de pagamento j� definidos.';
              $050D: Mensagem := Mensagem + 'Meio de pagamento j� definido.';
              $050E: Mensagem := Mensagem + 'Meio de pagamento inv�lido.';
              $050F: Mensagem := Mensagem + 'Descri��o do meio de pagamento inv�lido.';
              $0510: Mensagem := Mensagem + 'Valor m�ximo de desconto inv�lido.';
              $0513: Mensagem := Mensagem + 'Logotipo do usu�rio inv�lido.';
              $0514: Mensagem := Mensagem + 'Seq��ncia de logotipo inv�lido.';
              $0515: Mensagem := Mensagem + 'Configura��o de display inv�lida.';
              $0516: Mensagem := Mensagem + 'Dados do MICR inv�lidos.';
              $0517: Mensagem := Mensagem + 'Campo de endere�o inv�lido.';
              $0518: Mensagem := Mensagem + 'Nome da loja n�o definido.';
              $0519: Mensagem := Mensagem + 'Dados fiscais n�o definidos.';
              $510A: Mensagem := Mensagem + 'N�mero seq�encial do ECF inv�lido.';
              $510B: Mensagem := Mensagem + 'Simbologia do GT inv�lida, devem ser todos diferentes.';
              $510C: Mensagem := Mensagem + 'N�mero de CNPJ inv�lido.';
              $051D: Mensagem := Mensagem + 'Senha de fiscaliza��o inv�lida.';
              $051E: Mensagem := Mensagem + '�ltimo documento deve ser uma redu��o Z.';
              $051F: Mensagem := Mensagem + 'S�mbolo da moeda igual ao atualmente cadastrado.';
              $0520: Mensagem := Mensagem + 'Identifica��o da al�quota n�o cadastrada.';
              $0521: Mensagem := Mensagem + 'Al�quota n�o cadastrada.';
              $0601: Mensagem := Mensagem + 'Mem�ria de Fita-detalhe esgotada.';
              $0605: Mensagem := Mensagem + 'N�mero de s�rie invalido para a Mem�ria de Fita-detalhe.';
              $0606: Mensagem := Mensagem + 'Mem�ria de Fita-detalhe n�o iniciada.';
              $0607: Mensagem := Mensagem + 'Mem�ria de Fita-detalhe n�o pode estar iniciada.';
              $0608: Mensagem := Mensagem + 'N�mero de s�rie da Mem�ria de Fita-detalhe n�o confere.';
              $0609: Mensagem := Mensagem + 'Erro Interno na Mem�ria de Fita-detalhe.';
              $0701: Mensagem := Mensagem + 'Valor inv�lido para o n�mero do registro.';
              $0702: Mensagem := Mensagem + 'Valor inv�lido para o n�mero do item.';
              $0703: Mensagem := Mensagem + 'Intervalo inv�lido para a leitura da MFD.';
              $0704: Mensagem := Mensagem + 'N�mero de usu�rio inv�lido para MFD.';
              $0801: Mensagem := Mensagem + 'Comando inv�lido com jornada fiscal fechada.';
              $0802: Mensagem := Mensagem + 'Comando inv�lido com jornada fiscal aberta.';
              $0803: Mensagem := Mensagem + 'Mem�ria Fiscal esgotada.';
              $0804: Mensagem := Mensagem + 'Jornada fiscal deve ser fechada.';
              $0805: Mensagem := Mensagem + 'N�o h� meios de pagamento definidos.';
              $0806: Mensagem := Mensagem + 'Excesso de meios de pagamento utilizados na jornada fiscal.';
              $0807: Mensagem := Mensagem + 'Jornada fiscal sem movimento de vendas.';
              $0808: Mensagem := Mensagem + 'Intervalo de jornada fiscal inv�lido.';
              $0809: Mensagem := Mensagem + 'Existem mais dados para serem lidos.';
              $800A: Mensagem := Mensagem + 'N�o existem mais dados para serem lidos.';
              $800B: Mensagem := Mensagem + 'N�o pode abrir jornada fiscal.';
              $800C: Mensagem := Mensagem + 'N�o pode fechar jornada fiscal.';
              $080D: Mensagem := Mensagem + 'Limite m�ximo do per�odo fiscal atingido.';
              $080E: Mensagem := Mensagem + 'Limite m�ximo do per�odo fiscal n�o atingido.';
              $080F: Mensagem := Mensagem + 'Abertura da jornada fiscal n�o permitida.';
              $0901: Mensagem := Mensagem + 'Valor muito grande.';
              $0902: Mensagem := Mensagem + 'Valor muito pequeno.';
              $0903: Mensagem := Mensagem + 'Itens em excesso.';
              $0904: Mensagem := Mensagem + 'Al�quotas em excesso.';
              $0905: Mensagem := Mensagem + 'Desconto ou acr�scimos em excesso.';
              $0906: Mensagem := Mensagem + 'Meios de pagamento em excesso.';
              $0907: Mensagem := Mensagem + 'Item n�o encontrado.';
              $0908: Mensagem := Mensagem + 'Meio de pagamento n�o encontrado.';
              $0909: Mensagem := Mensagem + 'Total nulo.';
              $900C: Mensagem := Mensagem + 'Tipo de pagamento n�o definido.';
              $090F: Mensagem := Mensagem + 'Al�quota n�o encontrada.';
              $0910: Mensagem := Mensagem + 'Al�quota inv�lida.';
              $0911: Mensagem := Mensagem + 'Excesso de meios de pagamento com CDC.';
              $0912: Mensagem := Mensagem + 'Meio de pagamento com CDC j� emitido.';
              $0913: Mensagem := Mensagem + 'Meio de pagamento com CDC ainda n�o emitido.';
              $0914: Mensagem := Mensagem + 'Leitura da Mem�ria Fiscal � intervalo CRZ inv�lido.';
              $0915: Mensagem := Mensagem + 'Leitura da Mem�ria Fiscal � intervalo de data inv�lido.';
              $0A01: Mensagem := Mensagem + 'Opera��o n�o permitida ap�s desconto / acr�scimo.';
              $0A02: Mensagem := Mensagem + 'Opera��o n�o permitida ap�s registro de pagamentos.';
              $0A03: Mensagem := Mensagem + 'Tipo de item inv�lido.';
              $0A04: Mensagem := Mensagem + 'Linha de descri��o em branco.';
              $0A05: Mensagem := Mensagem + 'Quantidade muito pequena.';
              $0A06: Mensagem := Mensagem + 'Quantidade muito grande.';
              $0A07: Mensagem := Mensagem + 'Total do item com valor muito alto.';
              $0A08: Mensagem := Mensagem + 'Opera��o n�o permitida antes do registro de pagamentos.';
              $0A09: Mensagem := Mensagem + 'Registro de pagamento incompleto.';
              $0A0A: Mensagem := Mensagem + 'Registro de pagamento finalizado.';
              $0A0B: Mensagem := Mensagem + 'Valor pago inv�lido.';
              $0A0C: Mensagem := Mensagem + 'Valor de desconto ou acr�scimo n�o permitido.';
              $0A0E: Mensagem := Mensagem + 'Valor n�o pode ser zero.';
              $0A0F: Mensagem := Mensagem + 'Opera��o n�o permitida antes do registro de itens.';
              $0A11: Mensagem := Mensagem + 'Cancelamento de desconto e acr�scimo somente para item atual.';
              $0A12: Mensagem := Mensagem + 'N�o foi poss�vel cancelar �ltimo Cupom Fiscal.';
              $0A13: Mensagem := Mensagem + '�ltimo Cupom Fiscal n�o encontrado.';
              $0A14: Mensagem := Mensagem + '�ltimo Comprovante N�o-Fiscal n�o encontrado.';
              $0A15: Mensagem := Mensagem + 'Cancelamento de CDC necess�ria.';
              $0A16: Mensagem := Mensagem + 'N�mero de item em Cupom Fiscal inv�lido.';
              $0A17: Mensagem := Mensagem + 'Opera��o somente permitida ap�s subtotaliza��o.';
              $0A18: Mensagem := Mensagem + 'Opera��o somente permitida durante a venda de itens.';
              $0A19: Mensagem := Mensagem + 'Opera��o n�o permitida em item com desconto ou acr�scimo.';
              $0A1A: Mensagem := Mensagem + 'D�gitos de quantidade inv�lidos.';
              $0A1B: Mensagem := Mensagem + 'D�gitos de valor unit�rio inv�lido.';
              $0A1C: Mensagem := Mensagem + 'N�o h� desconto ou acr�scimo a cancelar.';
              $0A1D: Mensagem := Mensagem + 'N�o h� item para cancelar.';
              $0A1E: Mensagem := Mensagem + 'Desconto ou acr�scimo somente no item atual.';
              $0A1F: Mensagem := Mensagem + 'Desconto ou acr�scimo j� efetuado.';
              $0A20: Mensagem := Mensagem + 'Desconto ou acr�scimo nulo n�o permitido.';
              $0A21: Mensagem := Mensagem + 'Valor unit�rio inv�lido.';
              $0A22: Mensagem := Mensagem + 'Quantidade inv�lida.';
              $0A23: Mensagem := Mensagem + 'C�digo de item inv�lido.';
              $0A24: Mensagem := Mensagem + 'Descri��o inv�lida.';
              $0A25: Mensagem := Mensagem + 'Opera��o de desconto ou acr�scimo n�o permitida.';
              $0A26: Mensagem := Mensagem + 'Mensagem promocional j� impressa.';
              $0A27: Mensagem := Mensagem + 'Linhas adicionais n�o podem ser impressas.';
              $0A28: Mensagem := Mensagem + 'Dados do consumidor j� impresso.';
              $0A29: Mensagem := Mensagem + 'Dados do consumidor somente no fim do documento.';
              $0A2A: Mensagem := Mensagem + 'Dados do consumidor somente no inicio do documento.';
              $0A2B: Mensagem := Mensagem + 'Comando Inv�lido para o item.';
              $0E01: Mensagem := Mensagem + 'N�mero de linhas em documento excedido.';
              $0E02: Mensagem := Mensagem + 'N�mero do relat�rio inv�lido.';
              $0E03: Mensagem := Mensagem + 'Opera��o n�o permitida ap�s registro de itens.';
              $0E04: Mensagem := Mensagem + 'Registro de valor nulo n�o permitido.';
              $0E05: Mensagem := Mensagem + 'N�o h� desconto a cancelar.';
              $0E06: Mensagem := Mensagem + 'N�o h� acr�scimo a cancelar.';
              $0E07: Mensagem := Mensagem + 'Opera��o somente permitida ap�s subtotaliza��o.';
              $0E08: Mensagem := Mensagem + 'Opera��o somente permitida durante registro de itens.';
              $0E09: Mensagem := Mensagem + 'Opera��o n�o-fiscal inv�lida.';
              $0E0A: Mensagem := Mensagem + '�ltimo comprovante N�o-Fiscal n�o encontrado.';
              $0E0B: Mensagem := Mensagem + 'Meio de pagamento n�o encontrado.';
              $0E0C: Mensagem := Mensagem + 'N�o foi poss�vel imprimir nova via.';
              $0E0D: Mensagem := Mensagem + 'N�o foi poss�vel realizar reimpress�o.';
              $0E0E: Mensagem := Mensagem + 'N�o foi poss�vel imprimir nova parcela.';
              $0E0F: Mensagem := Mensagem + 'N�o h� mais parcelas a imprimir.';
              $0E10: Mensagem := Mensagem + 'Registro de item N�o-Fiscal inv�lido.';
              $0E11: Mensagem := Mensagem + 'Desconto ou acr�scimo j� efetuado.';
              $0E12: Mensagem := Mensagem + 'Valor de desconto ou acr�scimo inv�lido.';
              $0E13: Mensagem := Mensagem + 'N�o foi poss�vel cancelar o item.';
              $0E14: Mensagem := Mensagem + 'Itens em excesso.';
              $0E15: Mensagem := Mensagem + 'Opera��o N�o-Fiscal n�o cadastrada.';
              $0E16: Mensagem := Mensagem + 'Excesso de relat�rios / opera��es n�o-fiscais cadastradas.';
              $0E17: Mensagem := Mensagem + 'Relat�rio n�o encontrado.';
              $0E18: Mensagem := Mensagem + 'Comando n�o permitido.';
              $0E19: Mensagem := Mensagem + 'Comando n�o permitido em opera��es n�o-fiscais para movimento de monet�rio.';
              $0E1A: Mensagem := Mensagem + 'Comando permitido apenas em opera��es n�o-fiscais para movimento de monet�rio.';
              $0E1B: Mensagem := Mensagem + 'N�mero de parcelas inv�lido para a emiss�o de CCD.';
              $0E1C: Mensagem := Mensagem + 'Opera��o n�o fiscal j� cadastrada.';
              $0E1D: Mensagem := Mensagem + 'Relat�rio gerencial j� cadastrado.';
              $0E1E: Mensagem := Mensagem + 'Relat�rio Gerencial Inv�lido.';
              $3001: Mensagem := Mensagem + 'Configura��o de cheque n�o registrada.';
              $3002: Mensagem := Mensagem + 'Configura��o de cheque n�o encontrada.';
              $3003: Mensagem := Mensagem + 'Valor do cheque j� impresso.';
              $3004: Mensagem := Mensagem + 'Nominal ao cheque j� impresso.';
              $3005: Mensagem := Mensagem + 'Linhas adicionais no cheque j� impresso.';
              $3006: Mensagem := Mensagem + 'Autentica��o j� impressa.';
              $3007: Mensagem := Mensagem + 'N�mero m�ximo de autentica��es j� impresso.';
            else
              Mensagem := Mensagem + 'Erro desconhecido.';
            end;
          end;

          if Mensagem <> '' then
            Result := Mensagem;
        end;
end;

// -------------------------------------------------------------------------- //
// Abrir porta Serial do ECF

function cECF_Abre(COD_ECF: Integer; Porta: string): string;
var
  sVelocidade: string;
  sPorta: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
    Result := OK
  else
    if COD_ECF = DARUMA then
      Result := OK
    else
      if COD_ECF = SWEDA then
        Result := OK
      else
        if COD_ECF = EPSON then
        begin
          Result := OK;

          SetLength(sVelocidade, 8);
          SetLength(sPorta, 4);
          iRetorno := EPSON_Serial_Abrir_PortaAD(pchar(sVelocidade), pchar(sPorta));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON);
        end
        else
          if COD_ECF = EPSON then
          begin
            Result := OK;

            SetLength(sVelocidade, 8);
            SetLength(sPorta, 4);
            iRetorno := EPSON_Serial_Abrir_PortaAD(pchar(sVelocidade), pchar(sPorta));

            if iRetorno <> 0 then
              Result := cECF_Analisa_Retorno(EPSON);

          end;
end;

// -------------------------------------------------------------------------- //
// Fechar porta Serial do ECF

function cECF_Fecha(COD_ECF: Integer): string;
begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
    Result := OK
  else
    if COD_ECF = DARUMA then
      Result := OK
    else
      if COD_ECF = SWEDA then
        iRetorno := ECF_FechaPortaSerial()
      else
        if COD_ECF = EPSON then
        begin
          iRetorno := EPSON_Serial_Fechar_Porta;
          Result := cECF_Analisa_Retorno(EPSON);
        end
        else
          if COD_ECF = EPSON then
          begin
            iRetorno := EPSON_Serial_Fechar_Porta;

            if iRetorno <> 0 then
              Result := cECF_Analisa_Retorno(EPSON)
            else
              Result := OK;
          end;
end;

// -------------------------------------------------------------------------- //
// INFORMACAOES
// Verificar Impressora Ligada

function cECF_Ligada(COD_ECF: Integer): string;
begin
  Result := ERRO;
  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_VerificaImpressoraLigada();
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_VerificaImpressoraLigada();
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_VerificaImpressoraLigada();
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          Result := EPSON_ECFLigada;
        end;
end;

// -------------------------------------------------------------------------- //
// Retornar o numero de Serie do ECF

function cECF_Numero_Serie(COD_ECF: Integer): string;
var
  sRet: string;
  i: integer;
  Numero: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    // no arquivo bemafi.ini mude a chave da impressora para 1
    for i := 1 to 20 do Numero := Numero + ' ';
    iRetorno := Bematech_FI_NumeroSerieMFD(Numero);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);

    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
      begin
        if Pos(#0, Numero) > 0 then
          Numero := copy(Numero, 1, Pos(#0, Numero));

        Result := Numero
      end
      else
      begin
        Result := sRet;
      end;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 20 do Numero := Numero + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('78', numero);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := Numero
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 20 do Numero := Numero + ' ';
        iRetorno := ECF_NumeroSerieMFD(Numero);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := Numero
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          Result := EPSON_NumeroSerie;
        end;
end;

// -------------------------------------------------------------------------- //
// Verificar Numero do Caixa

function cECF_Numero_Caixa(COD_ECF: Integer): string;
var
  sRet: string;
  i: integer;
  Numero: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 4 do Numero := Numero + ' ';
    iRetorno := Bematech_FI_NumeroCaixa(Numero);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := copy(Numero, 2, 3)
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 4 do Numero := Numero + ' ';
      iRetorno := Daruma_FI_NumeroCaixa(Numero);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := copy(Numero, 2, 3)
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 4 do Numero := Numero + ' ';
        iRetorno := ECF_NumeroCaixa(Numero);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := copy(Numero, 2, 3)
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          Result := EPSON_NumeroCaixa;
        end;
end;

// -------------------------------------------------------------------------- //
// Retornar Numero do Cupom Fiscal (COO)

function cECF_Numero_Cupom(COD_ECF: Integer): string;
var
  sRet: string;
  I: integer;
  Numero: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 6 do Numero := Numero + ' ';
    iRetorno := Bematech_FI_NumeroCupom(Numero);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := Numero
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 6 do Numero := Numero + ' ';
      iRetorno := Daruma_FI_NumeroCupom(Numero);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := Numero
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 6 do Numero := Numero + ' ';
        iRetorno := ECF_NumeroCupom(Numero);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := Numero
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 84);
          iRetorno := EPSON_Obter_Contadores(pchar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Retorno_Impressora(EPSON)
          else
            Result := Copy(sRet, 1, 6);
        end;
end;

// -------------------------------------------------------------------------- //
// Retornar Numero do COO para comprovantes nao fiscal SUPRIMENTO, SANGRIA, RECEBIMENTO....
// devido a diferenca da posicao que o comando eh acionado pelo aplicativo
// bematech, sweda e EPSON acrescentar 1

function cECF_COO_Nao_Fiscal(COD_ECF: Integer): string;
var
  sRet: string;
  I: integer;
  Numero: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 6 do Numero := Numero + ' ';
    iRetorno := Bematech_FI_NumeroCupom(Numero);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
      begin
        i := strtoint(numero) + 1;
        numero := zerar(IntToStr(i), 6);
        Result := Numero;
      end
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 6 do Numero := Numero + ' ';
      iRetorno := Daruma_FI_NumeroCupom(Numero);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := Numero
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 6 do Numero := Numero + ' ';
        iRetorno := ECF_NumeroCupom(Numero);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
          begin
            i := strtoint(numero) + 1;
            numero := zerar(IntToStr(i), 6);
            Result := Numero;
          end
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then // CGT: Est� pegando o COO Geral
        begin
          SetLength(sRet, 84);
          iRetorno := EPSON_Obter_Contadores(pchar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Retorno_Impressora(EPSON)
          else
            Result := Copy(sRet, 1, 6);

    {
    For i := 1 To 85 Do
      sRet := sRet + ' ';

    iRetorno := EPSON_Obter_Contadores(pchar(sRet));

    if iRetorno <> 0 then
      Result := cECF_Retorno_Impressora(EPSON)
    else
      Result := Copy(sRet, 31, 6); }

        end;
end;

// -------------------------------------------------------------------------- //
// Retornar numero do contador de cupom fiscal - CCF

function cECF_Numero_Contador_Cupom(COD_ECF: Integer): string;
var
  sRet: string;
  i: integer;
  Numero: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 6 do Numero := Numero + ' ';
    iRetorno := Bematech_FI_ContadorCupomFiscalMFD(Numero);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := Numero
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 6 do Numero := Numero + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('30', Numero);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := Numero
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 6 do Numero := Numero + ' ';
        iRetorno := ECF_ContadorCupomFiscalMFD(Numero);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          Result := Numero
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 84);

          iRetorno := EPSON_Obter_Contadores(pchar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := copy(sRet, 43, 6);

        end;
end;

// -------------------------------------------------------------------------- //
// Retornar numero do contador de relatorio gerencial

function cECF_Numero_Contador_Relatorio_Gerencial(COD_ECF: integer): string;
var
  sRet: string;
  i: integer;
  Numero: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 6 do Numero := Numero + ' ';
    iRetorno := Bematech_FI_ContadorRelatoriosGerenciaisMFD(Numero);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := Numero
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 6 do Numero := Numero + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('33', Numero);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := Numero
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 6 do Numero := Numero + ' ';
        iRetorno := ECF_ContadorRelatoriosGerenciaisMFD(Numero);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := Numero
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 84);
          iRetorno := EPSON_Obter_Contadores(pchar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Retorno_Impressora(EPSON)
          else
            Result := Copy(sRet, 37, 6);

        end;
end;

// -------------------------------------------------------------------------- //
// Retornar numero do contador de operacoes nao fiscais - CNF

function cECF_Numero_Contador_Operacao_NF(COD_ECF: integer): string;
var
  sRet: string;
  i: integer;
  Numero: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 6 do Numero := Numero + ' ';
    iRetorno := Bematech_FI_NumeroOperacoesNaoFiscais(Numero);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := Numero
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 6 do Numero := Numero + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('28', Numero);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := Numero
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 6 do Numero := Numero + ' ';
        iRetorno := ECF_NumeroOperacoesNaoFiscais(Numero);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := Numero
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 84);
          iRetorno := EPSON_Obter_Contadores(pchar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Retorno_Impressora(EPSON)
          else
            Result := Copy(sRet, 19, 6);

        end;
end;

// -------------------------------------------------------------------------- //
// Retornar numero do contador de comprovante de credito

function cECF_Numero_Contador_Comprovante_CD(COD_ECF: integer): string;
var
  sRet: string;
  i: integer;
  Numero: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 4 do Numero := Numero + ' ';
    iRetorno := Bematech_FI_ContadorComprovantesCreditoMFD(Numero);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := Numero
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 4 do Numero := Numero + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('45', Numero);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := Numero
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 4 do Numero := Numero + ' ';
        iRetorno := ECF_ContadorComprovantesCreditoMFD(Numero);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := Numero
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 84);
          iRetorno := EPSON_Obter_Contadores(pchar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Retorno_Impressora(EPSON)
          else
            Result := Copy(sRet, 25, 6);

        end;
end;

// -------------------------------------------------------------------------- //

function cECF_Numero_Contador_Gerencial(COD_ECF: integer): string;
var
  sRet: string;
  i: integer;
  Numero: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 659 do Numero := Numero + ' ';
    iRetorno := Bematech_FI_VerificaRelatorioGerencialMFD(Numero);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := copy(Numero, 1, 4)
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 80 do Numero := Numero + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('44', Numero);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        Result := copy(Numero, 1, 4)
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 3 to 659 do Numero := Numero + ' ';
        iRetorno := ECF_VerificaRelatorioGerencialMFD(Numero);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := copy(Numero, 1, 4)
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 84);
          iRetorno := EPSON_Obter_Contadores(pchar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Retorno_Impressora(EPSON)
          else
            Result := Copy(sRet, 37, 6);

        end;
end;

// -------------------------------------------------------------------------- //
// Retornar DATA e HORA impressora

function cECF_Data_Hora(COD_ECF: Integer): string;
var
  sDados: string;
  i: integer;
  data, hora: string;
begin
  Result := ERRO;

  if frmPrincipal.TipoImpressora <> fiscal then
  begin
    Result := DateTimeToStr(Now);
    Exit;
  end;

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 6 do Data := Data + ' ';
    for i := 1 to 6 do Hora := Hora + ' ';
    iRetorno := Bematech_FI_DataHoraImpressora(data, hora);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sDados := cECF_Retorno_Impressora(cod_ecf);
      if sDados = OK then
      begin
        insert('/', data, 3);
        insert('/20', data, 6);
        insert(':', hora, 3);
        insert(':', hora, 6);
        Result := data + ' ' + hora;
      end
      else
        Result := sDados;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 6 do Data := Data + ' ';
      for i := 1 to 6 do Hora := Hora + ' ';
      iRetorno := Daruma_FI_DataHoraImpressora(data, hora);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sDados := cECF_Retorno_Impressora(cod_ecf);
        if sDados = OK then
        begin
          insert('/', data, 3);
          insert('/20', data, 6);
          insert(':', hora, 3);
          insert(':', hora, 6);
          Result := data + ' ' + hora;
        end
        else
          Result := sDados;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 6 do Data := Data + ' ';
        for i := 1 to 6 do Hora := Hora + ' ';
        iRetorno := ECF_DataHoraImpressora(data, hora);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sDados := cECF_Retorno_Impressora(cod_ecf);
          if sDados = OK then
          begin
            insert('/', data, 3);
            insert('/20', data, 6);
            insert(':', hora, 3);
            insert(':', hora, 6);
            Result := data + ' ' + hora;
          end
          else
            Result := sDados;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sDados, 14);
          iRetorno := EPSON_Obter_Hora_Relogio(PChar(sDados));

          Data := copy(sDados, 1, 8);
          Hora := copy(sDados, 9, 6);

          Insert('/', data, 3);
          Insert('/', data, 6);
          Insert(':', hora, 3);
          Insert(':', hora, 6);

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := Data + ' ' + Hora;

        end;
end;

// -------------------------------------------------------------------------- //
// Fazer o Download da MFD

function cECF_Download(COD_ECF: Integer; tipo: string; Inicio: string; Fim: string): string;
var
  sArq: string;
  sArqTroca: string;
  iTipo: Integer;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    if tipo = 'DATA' then tipo := '1';
    if tipo = 'COO' then tipo := '2';

    iRetorno := Bematech_FI_DownloadMFD(pchar(SystemDrive + '\DOWNLOAD.MFD'),
      pchar(tipo), pchar(inicio), pchar(fim), pchar('01'));

    ecfMSG := cECF_Analisa_Retorno(cod_ecf);

    if ecfMSG = OK then
    begin
      iretorno := Bematech_FI_FormatoDadosMFD(pchar(SystemDrive + '\DOWNLOAD.MFD'),
        pchar(SystemDrive + '\RETORNO.TXT'),
        '0',
        pchar(tipo),
        pchar(inicio),
        pchar(fim),
        pchar('01'));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);

      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      if tipo = 'DATA' then
      begin
      // formatar a data para: dd/mm/aa
        if length(inicio) = 10 then inicio := copy(inicio, 1, 6) + copy(inicio, 9, 2);
        if length(fim) = 10 then fim := copy(fim, 1, 6) + copy(fim, 9, 2);
      end;

      iRetorno := Daruma_FIMFD_DownloadDaMFD(pchar(inicio), pchar(fim));

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);

      if ecfMSG = OK then
      begin
        Result := cECF_Retorno_Impressora(cod_ecf)
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        if tipo = 'DATA' then tipo := '1';
        if tipo = 'COO' then tipo := '2';
        iRetorno := ECF_DownloadMFD(pchar('DOWNLOAD.MFD'), pchar(tipo), pchar(inicio), pchar(fim), pchar('01'));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          ecfMSG := cECF_Retorno_Impressora(cod_ecf);
          if ecfMSG = OK then
          begin
            iretorno := ECF_FormatoDadosMFD(pchar('DOWNLOAD.MFD'),
              pchar('RETORNO.TXT'),
              '0',
              pchar(tipo),
              pchar(inicio),
              pchar(fim),
              pchar('01'));
            ecfMSG := cECF_Analisa_Retorno(cod_ecf);
            if ecfMSG = OK then
              Result := cECF_Retorno_Impressora(cod_ecf)
            else
              Result := ecfMSG;
          end
          else
            Result := ecfMSG;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          if Tipo = 'DATA' then
          begin
            try
              inicio := FormatDateTime('ddmmyyyy', StrToDate(inicio));
            except
              Result := 'Data inicial inv�lida!';
              Exit;
            end;

            try
              fim := FormatDateTime('ddmmyyyy', StrToDate(fim));
            except
              Result := 'Data final inv�lida!';
              Exit;
            end;
          end;

          sArq := SystemDrive + '\Retorno.txt';

          if FileExists(sArq) then
            DeleteFile(sArq);

          if Tipo = 'DATA' then
            iTipo := 0 // Por Data
          else
            iTipo := 2; // Por COO

    // CGT: Desabilita a assinatura digital do Arquivo
          iRetorno := EPSON_Config_Habilita_EAD(false);

          iRetorno := EPSON_Obter_Dados_MF_MFD(pchar(inicio),
            pchar(fim), iTipo, 65535, 0, 0, pchar(SystemDrive + '\Retorno'));

          if iRetorno <> 0 then
          begin
            Result := cECF_Analisa_Retorno(EPSON);
          end
          else
          begin
            sArqTroca := copy(sArq, 1, Pos('.', sArq) - 1) + '_ESP.txt';

            RenameFile(sArqTroca, sArq);

            if FileExists(sArq) then
              Result := OK
            else
              Result := 'ERRO! Arquivo n�o encontrado.';

          end;
        end;
end;

// -------------------------------------------------------------------------- //
// Criar o registro 60A (sintegra)

function cECF_Registro60A(COD_ECF: Integer): string;
var
  sArq: string;
  sArqTroca: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_RelatorioTipo60Analitico();
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_RelatorioTipo60Analitico();
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_RelatorioTipo60Analitico();
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          sArq := SystemDrive + '\Retorno.txt';

          if FileExists(sArq) then
            DeleteFile(sArq);

          iRetorno := EPSON_Obter_Dados_MF_MFD(pchar('000000'),
            pchar('000000'), 2, 0, 0, 2, pchar(SystemDrive + '\Retorno'));

          if iRetorno <> 0 then
          begin
            Result := cECF_Analisa_Retorno(EPSON);
          end
          else
          begin
            sArqTroca := copy(sArq, 1, Pos('.', sArq) - 1) + '_SIN.txt';

            RenameFile(sArqTroca, sArq);

            if FileExists(sArq) then
              Result := OK
            else
              Result := 'ERRO! Arquivo n�o encontrado.';

          end;
        end;
end;

// -------------------------------------------------------------------------- //
// Criar o registro 60M (sintegra)

function cECF_Registro60M(COD_ECF: Integer): string;
var
  sArq: string;
  sArqTroca: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_RelatorioTipo60Mestre();
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end;
  if COD_ECF = DARUMA then
  begin
    iRetorno := Daruma_FI_RelatorioTipo60Mestre();
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end;
  if COD_ECF = SWEDA then
  begin
    iRetorno := ECF_RelatorioTipo60Mestre();
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = EPSON then
    begin
      sArq := SystemDrive + '\Retorno.txt';

      if FileExists(sArq) then
        DeleteFile(sArq);

      iRetorno := EPSON_Obter_Dados_MF_MFD(pchar('000000'),
        pchar('000000'), 2, 0, 0, 1, pchar(SystemDrive + '\Retorno'));

      if iRetorno <> 0 then
      begin
        Result := cECF_Analisa_Retorno(EPSON);
      end
      else
      begin
        sArqTroca := copy(sArq, 1, Pos('.', sArq) - 1) + '_SIN.txt';

        RenameFile(sArqTroca, sArq);

        if FileExists(sArq) then
          Result := OK
        else
          Result := 'ERRO! Arquivo n�o encontrado.';

      end;
    end;
end;

// -------------------------------------------------------------------------- //
// L� as formas de pagamento

function cECF_Le_Formas_Pgto(COD_ECF: Integer): string;
var
  sRet: string;
  i, x, Y: integer;
  Formas, sretorno_forma, svalor: string;

begin
  Result := ERRO;
  frmmodulo.tbForma_Pgto.Open;
  frmModulo.tbForma_Pgto.Refresh;

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 919 do Formas := Formas + ' ';
    iRetorno := Bematech_FI_VerificaFormasPagamentoMFD(Formas);

    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
      begin
          // limpar a tabela de forma de pagamento
        Y := 0;

        for i := 1 to length(Formas) do
        begin
          if Y > 30 then break;
          if i = 1 then // inicio da variavel
            x := 1
          else
            if i >= length(Formas) then // final da variavel
            begin
              frmModulo.tbForma_Pgto.Insert;
              frmModulo.tbForma_Pgto.FieldByName('id').asinteger := y;
              frmModulo.tbForma_Pgto.FieldByName('Nome').asstring := copy(Formas, x, 16);
              svalor := copy(Formas, x + 16, 20);
              if svalor <> '' then
              begin
                svalor := floattostr(strtofloat(svalor));
                if strtofloat(svalor) > 0 then
                  svalor := floattostr(strtofloat(svalor) / 100);
              end
              else
                svalor := '0';

              frmModulo.tbForma_pgto.fieldbyname('Valor_Acumulado').asfloat
                := strtofloat(svalor);

              svalor := copy(Formas, x + 26, 20);
              if svalor <> '' then
              begin
                svalor := floattostr(strtofloat(svalor));
                if strtofloat(svalor) > 0 then
                  svalor := floattostr(strtofloat(svalor) / 100);
              end
              else
                svalor := '0';

              frmModulo.tbForma_Pgto.FieldByName('Valor_Ultimo_Cupom').asfloat
                := strtofloat(svalor);
              frmModulo.tbForma_Pgto.Post;
              INC(Y);
            end
            else
            begin
              if Formas[i] = ',' then
              begin
                frmModulo.tbForma_Pgto.Insert;
                frmModulo.tbForma_Pgto.FieldByName('id').asinteger := y;
                frmModulo.tbForma_Pgto.FieldByName('Nome').asstring := copy(Formas, x, 16);
                svalor := copy(Formas, x + 16, 20);
                if svalor <> '' then
                begin
                  svalor := floattostr(strtofloat(svalor));
                  if strtofloat(svalor) > 0 then
                    svalor := floattostr(strtofloat(svalor) / 100);
                end
                else
                  svalor := '0';
                frmModulo.tbForma_Pgto.FieldByName('Valor_Acumulado').asfloat
                  := strtofloat(svalor);
                svalor := copy(Formas, x + 26, 20);
                if svalor <> '' then
                begin
                  svalor := floattostr(strtofloat(svalor));
                  if strtofloat(svalor) > 0 then
                    svalor := floattostr(strtofloat(svalor) / 100);
                end
                else
                  svalor := '0';
                frmModulo.tbForma_Pgto.FieldByName('Valor_Ultimo_Cupom').asfloat
                  := strtofloat(svalor);
                INC(Y);
                x := i + 1;
              end;
            end;
        end;
        Result := OK;
      end
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 1027 do Formas := Formas + ' ';
      iRetorno := Daruma_FI_VerificaFormasPagamentoEx(Formas);


      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
        begin
          Y := 0;

          for i := 1 to length(Formas) do
          begin
            if Y > 30 then break;
            if i = 1 then // inicio da variavel
              x := 1
            else
              if i >= length(Formas) then // final da variavel
              begin
                frmModulo.tbForma_Pgto.Insert;
                frmModulo.tbForma_Pgto.FieldByName('id').asinteger := y;
                frmModulo.tbForma_Pgto.FieldByName('Nome').asstring := copy(Formas, x, 16);
                svalor := copy(Formas, x + 16, 20);
                if svalor <> '' then
                begin
                  svalor := floattostr(strtofloat(svalor));
                  if strtofloat(svalor) > 0 then
                    svalor := floattostr(strtofloat(svalor) / 100);
                end
                else
                  svalor := '0';
                frmModulo.tbForma_Pgto.FieldByName('Valor_Acumulado').asfloat :=
                  strtofloat(svalor);

                svalor := copy(Formas, x + 26, 20);
                if svalor <> '' then
                begin
                  svalor := floattostr(strtofloat(svalor));
                  if strtofloat(svalor) > 0 then
                    svalor := floattostr(strtofloat(svalor) / 100);
                end
                else
                  svalor := '0';
                frmModulo.tbForma_Pgto.FieldByName('Valor_Ultimo_Cupom').asfloat
                  := strtofloat(svalor);
                INC(Y);
              end
              else
              begin
                if Formas[i] = ',' then
                begin

                  frmModulo.tbForma_Pgto.Insert;
                  frmModulo.tbForma_Pgto.FieldByName('id').asinteger := y;
                  frmModulo.tbForma_Pgto.FieldByName('Nome').asstring := copy(Formas, x, 16);
                  svalor := copy(Formas, x + 16, 20);
                  if svalor <> '' then
                  begin
                    svalor := floattostr(strtofloat(svalor));
                    if strtofloat(svalor) > 0 then
                      svalor := floattostr(strtofloat(svalor) / 100);
                  end
                  else
                    svalor := '0';
                  frmModulo.tbForma_Pgto.FieldByName('Valor_Acumulado').asfloat :=
                    strtofloat(svalor);
                  svalor := copy(Formas, x + 26, 20);
                  if svalor <> '' then
                  begin
                    svalor := floattostr(strtofloat(svalor));
                    if strtofloat(svalor) > 0 then
                      svalor := floattostr(strtofloat(svalor) / 100);
                  end
                  else
                    svalor := '0';
                  frmModulo.tbForma_Pgto.FieldByName('Valor_Ultimo_Cupom').asfloat :=
                    strtofloat(svalor);
                  INC(Y);
                  x := i + 1;
                end;
              end;
          end;
          Result := OK;
        end
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 1045 do Formas := Formas + ' ';
        iRetorno := ECF_verificaFormasPagamentoEx(Formas);


        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
          begin
            Y := 0;

            for i := 1 to length(Formas) do
            begin
              if Y > 30 then break;
              if i = 1 then // inicio da variavel
                x := 1
              else
                if i >= length(Formas) then // final da variavel
                begin
                  frmModulo.tbForma_Pgto.Insert;
                  frmModulo.tbForma_Pgto.FieldByName('id').asinteger := y;
                  frmModulo.tbForma_Pgto.FieldByName('Nome').asstring := copy(Formas, x, 16);
                  svalor := copy(Formas, x + 16, 20);
                  if svalor <> '' then
                  begin
                    svalor := floattostr(strtofloat(svalor));
                    if strtofloat(svalor) > 0 then
                      svalor := floattostr(strtofloat(svalor) / 100);
                  end
                  else
                    svalor := '0';
                  frmModulo.tbForma_Pgto.FieldByName('Valor_Acumulado').asfloat :=
                    strtofloat(svalor);

                  svalor := copy(Formas, x + 26, 20);
                  if svalor <> '' then
                  begin
                    svalor := floattostr(strtofloat(svalor));
                    if strtofloat(svalor) > 0 then
                      svalor := floattostr(strtofloat(svalor) / 100);
                  end
                  else
                    svalor := '0';
                  frmModulo.tbForma_Pgto.FieldByName('Valor_Ultimo_Cupom').asfloat
                    := strtofloat(svalor);
                  INC(Y);
                end
                else
                begin
                  if Formas[i] = ',' then
                  begin

                    frmModulo.tbForma_Pgto.Insert;
                    frmModulo.tbForma_Pgto.FieldByName('id').asinteger := y;
                    frmModulo.tbForma_Pgto.FieldByName('Nome').asstring := copy(Formas, x, 16);
                    svalor := copy(Formas, x + 16, 20);
                    if svalor <> '' then
                    begin
                      svalor := floattostr(strtofloat(svalor));
                      if strtofloat(svalor) > 0 then
                        svalor := floattostr(strtofloat(svalor) / 100);
                    end
                    else
                      svalor := '0';
                    frmModulo.tbForma_Pgto.FieldByName('Valor_Acumulado').asfloat :=
                      strtofloat(svalor);
                    svalor := copy(Formas, x + 26, 20);
                    if svalor <> '' then
                    begin
                      svalor := floattostr(strtofloat(svalor));
                      if strtofloat(svalor) > 0 then
                        svalor := floattostr(strtofloat(svalor) / 100);
                    end
                    else
                      svalor := '0';
                    frmModulo.tbForma_Pgto.FieldByName('Valor_Ultimo_Cupom').asfloat :=
                      strtofloat(svalor);
                    INC(Y);
                    x := i + 1;
                  end;
                end;
            end;
            Result := OK;
          end
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;

      end
      else
        if COD_ECF = EPSON then
        begin
          Result := OK;
          SetLength(Formas, 881);

          iRetorno := EPSON_Obter_Tabela_Pagamentos(pchar(Formas));

          if iRetorno = 0 then
          begin
            while trim(Formas) <> '' do
            begin
              with frmModulo.tbForma_Pgto do
              begin
                if trim(copy(Formas, 3, 15)) <> '' then
                begin
                  Insert;
                  FieldByName('id').AsInteger := StrToInt(copy(Formas, 1, 2));
                  FieldByName('Nome').Asstring := copy(Formas, 3, 15);

                  sValor := copy(Formas, 18, 11) + DecimalSeparator + copy(Formas, 29, 2);
                  FieldByName('Valor_Acumulado').AsCurrency := StrToFloat(sValor);

                  sValor := copy(Formas, 31, 11) + DecimalSeparator + copy(Formas, 42, 2);
                  FieldByName('Valor_Ultimo_Cupom').AsCurrency := StrToFloat(sValor);
                end;
              end;

              Delete(Formas, 1, 44);
            end;

            Result := OK;
          end
          else
            Result := ecfMSG;

        end;
end;

// -------------------------------------------------------------------------- //
// Criar o registro CAT52
// 1 - Bematech --> OK
// 2 - Daruma   --> utiliza sistema UDECODER.exe
// 3 - Sweda    --> utiliza sistema SWmfd.exe
// 4 - Epson    --> OK

function cECF_Arquivo_Fiscal_CAT52(COD_ECF: integer; tipo, inicio, fim: string): string;
var
  sArq: string;
  sArqTroca: string;
  cArqDestino, sEntrada, sArquivo: string;
  i, dias, x: integer;
  Arquivo, sret: string;
  txt_mfd, txt_Cotepe, txt: textfile;
  dInicial, dFinal: TDate;
  cFlag, cDownload, cTipo, cTipoDow, cUsuario: string;
  iACK: Integer;
  iST1: Integer;
  iST2: Integer;
  iST3: Integer;
  E01, E02: string;
  E03, E04, E05, E06, E07, E08, E09, E10, E11, E12, E13, E14, E15, E16,
    E17, E18, E19, E20, E21, E22, E23, E24, E25: array[0..10000] of string;
  cArqMFD: string;
  cArqTXT: string;
  cFormato: string;
  cTipoDownload: string;
  cLinha: string;
  cDataInicial: string;
  cDataFinal: string;
  cArq1704: string;
  cCMD: string;
  cArqTemp: TextFile;
  cArqTempTXT: TextFile;
  Texto: TStringList;

//CTP_00107810_090507151646.txt

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    if tipo = 'DATA' then
    begin
      cFlag := '1';
      cDownload := 'Download.mfd';
      cTipo := '2';
      cTipoDow := '1';
      cUsuario := '1';

      IRetorno := Bematech_FI_DownloadMFD(pchar(cDownload), pchar(ctipodow), pchar(inicio), pchar(fim), pchar(cusuario));

      sArquivo := '.\txt\CTP' + zerar(sECF_Serial, 20) + '_' + somenteNumero(datetostr(dData_sistema)) +
        somenteNumero(timetostr(time)) + '.TXT';

      iRetorno := Bematech_FI_HabilitaDesabilitaRetornoEstendidoMFD(cflag);
      iRetorno := Bematech_FI_RetornoImpressoraMFD(iACK, iST1, iST2, iST3);

      iRetorno := BemaGeraRegistrosTipoE(cDownload, sarquivo, inicio, fim,
        sEmpresa_Nome, sEmpresa_Endereco,
        '', ctipo, '', '', '', '', '', '', '', '', '', '', '', '', '');
      Result := sarquivo;
    end
    else
    begin
      cArqMFD := 'Download.MFD';
      cTipo := '2';
      cUsuario := '1';

      // Fun��o que executa o download da MFD da impressora por COO.
      iRetorno := Bematech_FI_DownloadMFD(pchar(cArqMFD),
        pchar(cTipo),
        inicio,
        fim,
        pchar(cUsuario));
      cArqTXT := 'Espelho.TXT';
      cFormato := '0';
      cTipoDownload := '0';

      // Fun��o que formata os dados da MFD para texto.
      iRetorno := Bematech_FI_FormatoDadosMFD(pchar(cArqMFD),
        pchar(cArqTXT),
        pchar(cFormato),
        pchar(cTipoDownload),
        pchar(''),
        pchar(''),
        pchar(''));

      // Abre o arquivo Espelho.TXT com a imagem dos cupons capturados.
      AssignFile(cArqTemp, 'Espelho.TXT');
      Reset(cArqTemp);

      // Cria o arquivo EspelhoTMP.TXT para guardar a imagens dos cupons
      // capturados, retirando as linhas em branco.
      AssignFile(cArqTempTXT, 'EspelhoTMP.TXT');
      Rewrite(cArqTempTXT);

      cLinha := '';
      while not EOF(cArqTemp) do
      begin
        Readln(cArqTemp, cLinha);

        if (cLinha <> '') then
        begin
          Writeln(cArqTempTXT, cLinha);
        end;
      end;

      CloseFile(cArqTemp);
      CloseFile(cArqTempTXT);

      Assignfile(txt, 'EspelhoTMP.TXT');
      Reset(txt);

      while not eof(txt) do
      begin
        readln(txt, sentrada);

        if copy(sentrada, 39, 10) = 'COO:' + zerar(inicio, 6) then cDataInicial := copy(sentrada, 1, 10);
        if copy(sentrada, 39, 10) = 'COO:' + zerar(fim, 6) then cDatafinal := copy(sentrada, 1, 10);
      end;

{         // Cria um objeto do tipo TStringList.

       Texto := TStringList.Create;
       Texto.LoadFromFile( 'EspelhoTMP.TXT' );

       // Copia as informa��es de data inicial e final, dentro do objeto Texto.

       cDataInicial := copy( Texto.Strings[ 7 ], 1, 10 );
       cDataFinal   := copy( Texto.Strings[ Texto.Count - 2 ], 20, 10 );

       // Fun��o que executa a gera��o do arquivo no layout do Ato Cotepe 17/04
       // para o PAF-ECF, por intervalo de datas previamente capturadas.



//         showmessage(cDataInicial+' '+cDataFinal);

}
      cArq1704 := '.\txt\CTP1704.txt';
      cCMD := '2';

      iRetorno := BemaGeraRegistrosTipoE(pchar(cArqMFD),
        pchar(cArq1704),
        pchar(cDataInicial),
        pchar(cDataFinal),
        sEmpresa_nome,
        sEmpresa_endereco,
        '',
        pchar(cCMD),
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '');

      DeleteFile('Download.MFD');
      DeleteFile('Espelho.TXT');
      DeleteFile('EspelhoTMP.TXT');

      Result := cArq1704;
    end;
  end
  else
    if COD_ECF = DARUMA then
    begin
    // executar o UnDecoder da DAruma
      try
        if FileExists('WIN_uDecoder.exe') then
        begin
          Executa_Programa('WIN_uDecoder.exe', '', SW_SHOW);

          sMsg := cECF_Ligada(COD_ECF);

          if sECF_Diretorio_mfd <> '' then
          begin
            try
              frmmodulo.Dlg_arquivo.InitialDir := sECF_Diretorio_MFD;
              frmmodulo.Dlg_arquivo.Filter := 'Arquivo Texto|*.txt';
              frmmodulo.Dlg_arquivo.Title := 'Assinar arquivo';
              if frmModulo.Dlg_arquivo.Execute then
              begin
                sArquivo := frmmodulo.Dlg_arquivo.FileName;
                TirarEAD(sArquivo);
                assinatura_digital(sarquivo);
                Result := 'OK! Arquivo criado com sucesso!' + #13 +
                  'Local: ' + sArquivo;
              end
              else
                Result := 'Erro! Arquivo n�o assinado!';

            except
              Result := 'Erro ao acessar diret�rio de grava��o do arquivo MFD!';
            end;
          end
          else
            Result := 'N�o foi configurado o diret�rio de grava��o do arquivo MFD!';
        end
        else
          Result := 'Fun��o n�o suportada pelo modelo de ECF utilizado';
      except

      end;
    end
    else
      if COD_ECF = SWEDA then
      begin
        if tipo = 'DATA' then tipo := '1';
        if tipo = 'COO' then
        begin
          Zerar(inicio, 7);
          zerar(fim, 7);

          tipo := '2';
        end;

        IRetorno := ECF_DownloadMF(SystemDrive + '\SWEDA\MF.BIN');
        sArquivo := '.\txt\CTP' + zerar(sECF_Serial, 20) + '_' + somenteNumero(datetostr(dData_sistema)) +
          somenteNumero(timetostr(time)) + '.TXT';
        IRetorno := ECF_ReproduzirMemoriaFiscalMFD('2',
          INICIO,
          FIM,
          sarquivo,
          SystemDrive + '\SWEDA\MF.BIN');


        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          Result := sarquivo;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          sArq := SystemDrive + '\Retorno.txt';

          if FileExists(sArq) then
            DeleteFile(sArq);

          if Tipo = 'DATA' then
          begin
            I := 0; // Por Data

            try
              inicio := FormatDateTime('ddmmyyyy', StrToDate(inicio));
            except
              Result := 'Data inicial inv�lida!';
              Exit;
            end;

            try
              fim := FormatDateTime('ddmmyyyy', StrToDate(fim));
            except
              Result := 'Data final inv�lida!';
              Exit;
            end;
          end
          else
          begin
      // GUIO: ATEN��O - A op��o Arq. MFD do menu fiscal pede que  o invtervalo
      // para gerar o arquivo seja de DATA ou COO. Na impressora EPSON
      // o Ato Cotepe 17/04 n�o pode ser gerado pelo COO. O mesmo somente
      // pode ser gerado pela DATA ou pelo o CRZ. O valor 2 da vari�vel I indica
      // que a busca ser� feita pelo COO, logo, a linha est� desabilitada.
      // Deixei no software aparecer � nome COO na tela, por�m a busca esta
      // sendo feita pelo CRZ at� arrumar uma solu��o

      // I := 2; // Por COO desabilitado temporariamente

            I := 1; // Por CRZ
          end;

    // CGT: Desabilita a assinatura digital do Arquivo
          iRetorno := EPSON_Config_Habilita_EAD(false);

          iRetorno := EPSON_Obter_Dados_MF_MFD(pchar(inicio),
            pchar(fim), I, 0, 11, 0, pchar(SystemDrive + '\Retorno'));

          if iRetorno <> 0 then
          begin
            Result := cECF_Analisa_Retorno(EPSON);
          end
          else
          begin
            sArqTroca := copy(sArq, 1, Pos('.', sArq) - 1) + '_CTP.txt';
            sArq := '.\txt\CTP'
              + zerar(sECF_Serial, 20) + '_' + SomenteNumero(datetostr(dData_sistema))
              + somenteNumero(timetostr(time)) + '.TXT';

            RenameFile(sArqTroca, sArq);
            Result := sArq;
          end;
        end;
end;

// -------------------------------------------------------------------------- //
// Retorna a MARCA do ECF

function cECF_Marca_ECF(COD_ECF: integer): string;
var
  sMarca, sRet, sModelo, sTipo: string;
  i: integer;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 15 do sMarca := sMarca + ' ';
    for i := 1 to 20 do sModelo := sModelo + ' ';
    for i := 1 to 7 do sTipo := sTipo + ' ';

    iRetorno := Bematech_FI_MarcaModeloTipoImpressoraMFD(sMarca, sModelo, sTipo);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := sMarca
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 20 do smarca := smarca + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('80', smarca);

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := smarca
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 15 do sMarca := sMarca + ' ';
        for i := 1 to 20 do sModelo := sModelo + ' ';
        for i := 1 to 7 do sTipo := sTipo + ' ';

        iRetorno := ECF_MarcaModeloTipoImpressoraMFD(sMarca, sModelo, sTipo);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := sMarca
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 108);

          iRetorno := EPSON_Obter_Dados_Impressora(PChar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := copy(sRet, 41, 10);

        end;
end;

// -------------------------------------------------------------------------- //
// Retorna a MODELO do ECF

function cECF_Modelo_ECF(COD_ECF: integer): string;
var
  sMarca, sRet, sModelo, sTipo: string;
  i: integer;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 15 do sMarca := sMarca + ' ';
    for i := 1 to 20 do sModelo := sModelo + ' ';
    for i := 1 to 7 do sTipo := sTipo + ' ';

    iRetorno := Bematech_FI_MarcaModeloTipoImpressoraMFD(sMarca, sModelo, sTipo);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := sModelo
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 20 do sModelo := sModelo + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('81', sModelo);

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := sModelo
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 15 do sMarca := sMarca + ' ';
        for i := 1 to 20 do sModelo := sModelo + ' ';
        for i := 1 to 7 do sTipo := sTipo + ' ';

        iRetorno := ECF_MarcaModeloTipoImpressoraMFD(sMarca, sModelo, sTipo);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := sModelo
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 108);
          iRetorno := EPSON_Obter_Dados_Impressora(PChar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := copy(sRet, 61, 10);

        end;
end;

// -------------------------------------------------------------------------- //
// Retorna o TIPO do ECF

function cECF_Tipo_ECF(COD_ECF: integer): string;
var
  sMarca, sRet, sModelo, sTipo: string;
  i: integer;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 15 do sMarca := sMarca + ' ';
    for i := 1 to 20 do sModelo := sModelo + ' ';
    for i := 1 to 7 do sTipo := sTipo + ' ';

    iRetorno := Bematech_FI_MarcaModeloTipoImpressoraMFD(sMarca, sModelo, sTipo);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := sTipo
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 7 do stipo := stipo + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('79', stipo);

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := stipo
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 15 do sMarca := sMarca + ' ';
        for i := 1 to 20 do sModelo := sModelo + ' ';
        for i := 1 to 7 do sTipo := sTipo + ' ';

        iRetorno := ECF_MarcaModeloTipoImpressoraMFD(sMarca, sModelo, sTipo);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := sTipo
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 108);
          iRetorno := EPSON_Obter_Dados_Impressora(PChar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := copy(sRet, 81, 10);

        end;
end;

// -------------------------------------------------------------------------- //
// Retorna o numero da Memoria fiscal adicional

function cECF_MF_Adicional(COD_ECF: integer): string;
var
  i: integer;
  dataUsuario,
    dataSWBasico,
    MFAdicional,
    sRet: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    SetLength(dataUsuario, 20);
    SetLength(dataSWBasico, 20);
    SetLength(MFAdicional, 5);
    iRetorno := Bematech_FI_DataHoraGravacaoUsuarioSWBasicoMFAdicional(dataUsuario, dataSWBasico,
      MFAdicional);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := COPY(MFAdicional, 1, 1)
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
     // Daruma retorna em branco
      Result := ' ';
    end;
  if COD_ECF = SWEDA then
  begin
    SetLength(dataUsuario, 20);
    SetLength(dataSWBasico, 20);
    SetLength(MFAdicional, 5);
    iRetorno := ecf_DataHoraGravacaoUsuarioSWBasicoMFAdicional(dataUsuario, dataSWBasico,
      MFAdicional);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := COPY(MFAdicional, 1, 1)
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = EPSON then
    begin
    // Retorna em branco
      Result := ' ';
    end;
end;

// -------------------------------------------------------------------------- //
// Retorna a versao do software basico

function cECF_Versao_SB(COD_ECF: integer): string;
var
  sVersao,
    sRet: string;
  I: integer;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 6 do sVersao := sVersao + ' ';
    iRetorno := Bematech_FI_VersaoFirmwareMFD(sVersao);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := sVersao
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 6 do sVersao := sVersao + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('84', sVersao);

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := sVersao
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 6 do sVersao := sVersao + ' ';
        iRetorno := ECF_VersaoFirmwareMFD(sVersao);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := sVersao
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          Result := EPSON_VersaoSoftwareBasico;
        end;
end;

// -------------------------------------------------------------------------- //
// Retorna a data e hora da gravacao do software basico

function cECF_Data_Hora_SB(COD_ECF: integer): string;
var i: integer;
  dataUsuario,
    sdataHora,
    MFAdicional,
    sRet: string;
begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    SetLength(dataUsuario, 20);
    SetLength(sDataHora, 20);
    SetLength(MFAdicional, 5);
    iRetorno := Bematech_FI_DataHoraGravacaoUsuarioSWBasicoMFAdicional(dataUsuario, sdataHora,
      MFAdicional);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := somenteNumero(sDataHora)
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 14 do sDataHora := sDataHora + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('85', sDataHora);

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := sDataHora + '00'
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        SetLength(dataUsuario, 20);
        SetLength(sDataHora, 20);
        SetLength(MFAdicional, 5);
        iRetorno := ecf_DataHoraGravacaoUsuarioSWBasicoMFAdicional(dataUsuario, sdataHora,
          MFAdicional);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := somenteNumero(sDataHora)
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          Result := EPSON_DataHoraSoftwareBasico;
        end;
end;

// -------------------------------------------------------------------------- //
// Retornar o total do cupom
// CGT: fun��o ainda n�o �pe utilizada em nunhum lugar

function cECF_Total_Cupom(COD_ECF: integer): real;
var
  sValor: string;
  i: integer;
  rValor: real;
  sRet: string;

begin
  if COD_ECF = DARUMA then
  begin
    for i := 1 to 18 do sValor := sValor + ' ';
    iRetorno := Daruma_FI_SaldoAPagar(sValor);

    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
      begin
        rValor := strtofloat(svalor);
        if rvalor > 0 then rvalor := rvalor / 100;
        Result := rvalor;
      end
      else
        Result := 0;
    end
    else
      Result := 0;

  end;
end;

// -------------------------------------------------------------------------- //
// vERIFICAR se a reducao z estah automatica

function cECF_Verifica_Z_automatico(COD_ECF: integer): string;
var
  sValor: string;
  i: integer;
  sRet: string;
begin

  if COD_ECF = BEMATECH then
  begin
    i := 0;
    iRetorno := Bematech_FI_VerificaReducaoZAutomatica(i);

    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
      begin
        if i = 1 then
          Result := 'SIM'
        else
          Result := 'NAO';
      end
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;

  end
  else
    if COD_ECF = DARUMA then
    begin
      sValor := StringOFChar(#0, 50);
      iRetorno := Daruma_Registry_RetornaValor('ECF', 'ZAutomatica', sValor);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
        begin
          if copy(sValor, 1, 1) = '1' then
            Result := 'SIM'
          else
            Result := 'NAO';
        end
        else
          Result := sRet;
      end
      else
        Result := ecfMsg;

    end
    else
      if COD_ECF = SWEDA then
      begin
        SetLength(svalor, 50);
        iRetorno := ECF_Registry_RetornaValor('ECF', 'Zauto', sValor);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          if copy(sValor, 1, 1) = '1' then
            Result := 'SIM'
          else
            Result := 'NAO';
        end
        else
          Result := ecfMsg;

      end
      else
        if COD_ECF = EPSON then
        begin
    // CGT: Ao que parece a EPSON n�o emite a Redu��o Z automaticamente
          Result := 'NAO'
        end;
end;

// -------------------------------------------------------------------------- //
// verificar se impressora esta com horario de verao programado

function CECF_verifica_horario_verao(COD_ecf: INTEGER): string;
var
  sValor: string;
  i: integer;
  sRet: string;
  bHorarioVeraoAtivado: Boolean;

begin
  if COD_ECF = BEMATECH then
  begin
    i := 0;
    iRetorno := Bematech_FI_FlagsFiscais(i);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
      begin
        if i >= 128 then i := i - 128;
        if i >= 64 then i := i - 64;
        if i >= 32 then i := i - 32;
        if i >= 16 then i := i - 16;
        if i >= 8 then i := i - 8;
        if i in [4, 5, 6, 7] then
          Result := 'SIM'
        else
        begin
          Result := 'NAO';
        end;
      end
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      SetLength(svalor, 2);
      iRetorno := Daruma_FI_VerificaHorarioVerao(svalor);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
        begin
          if copy(sValor, 1, 1) = '1' then
            Result := 'SIM'
          else
            Result := 'NAO';
        end
        else
          Result := sRet;
      end
      else
        Result := ecfMsg;
    end
    else
      if COD_ECF = SWEDA then
      begin
        SetLength(svalor, 2);
        iRetorno := ecf_VerificaHorarioVerao(svalor);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          if copy(sValor, 1, 1) = '1' then
            Result := 'SIM'
          else
            Result := 'NAO';
        end
        else
          Result := ecfMsg;
      end
      else
        if COD_ECF = EPSON then
        begin
          iRetorno := EPSON_Obter_Estado_Horario_Verao(bHorarioVeraoAtivado);

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
          begin
            if bHorarioVeraoAtivado then
              Result := 'SIM'
            else
              Result := 'NAO';
          end;
        end;
end;

// -------------------------------------------------------------------------- //
// retornar as aliquotas cadastradas

function cECF_Verifica_Aliquotas(COD_ecf: integer): string;
var
  sContador, sRet: string;
  i: integer;

begin
  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 79 do sContador := sContador + ' ';
    iRetorno := Bematech_FI_RetornoAliquotas(sContador);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := sContador
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;

  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 79 do sContador := sContador + ' ';
      iRetorno := Daruma_FI_RetornoAliquotas(sContador);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := sContador
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;

    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 79 do sContador := sContador + ' ';
        iRetorno := ECF_RetornoAliquotas(PCHAR(sContador));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := sContador
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          for I := 0 to 553 do
            sRet := sRet + ' ';

          iRetorno := EPSON_Obter_Tabela_Aliquotas(pchar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
          begin
            sContador := '';
            I := 0;

      // GUIO: Separa as aliquotas
            while True do
            begin
              if (trim(sRet) = '') or (trim(sRet) = #0) then
                Break;

              sContador := sContador + ' ' + copy(sRet, 3, 4);
              Delete(sRet, 1, 23);
              Inc(I);
            end;

            Result := sContador;
          end;

        end;
end;

// -------------------------------------------------------------------------- //
// retorna os totalizadores nao fiscais

function cECF_Verifica_Totalizadores_NF(COD_ECF: integer): string;
var
  sContador, sRet: string;
  i: integer;
begin
  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 179 do sContador := sContador + ' ';
    iRetorno := Bematech_FI_VerificaTotalizadoresNaoFiscais(sContador);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := sContador
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 300 do sContador := sContador + ' ';
      iRetorno := Daruma_FI_VerificaTotalizadoresNaoFiscais(scontador);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := sContador
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 300 do sContador := sContador + ' ';
        iRetorno := ecf_VerificaTotalizadoresNaoFiscaisEX(pchar(scontador));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := sContador
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;

      end
      else
        if COD_ECF = EPSON then
        begin
          for I := 0 to 681 do
            sRet := sRet + ' ';

          iRetorno := EPSON_Obter_Tabela_NaoFiscais(pchar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := sRet;

        end;
end;

// -------------------------------------------------------------------------- //
// Retorna a data do Movimento do ECF

function cECF_Data_Movimento(cod_ECF: integer): string;
var
  sContador,
    sRet: string;
  i: integer;

begin
  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 6 do sContador := sContador + ' ';
    iRetorno := Bematech_FI_DataMovimento(sContador);

    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      Result := copy(scontador, 1, 2) + '/' +
        copy(scontador, 3, 2) + '/' +
        '20' + copy(scontador, 5, 2);
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 6 do sContador := sContador + ' ';
      iRetorno := Daruma_FI_DataMovimento(sContador);

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);

      if ecfMSG = OK then
      begin
        Result := copy(scontador, 1, 2) + '/' +
          copy(scontador, 3, 2) + '/' +
          '20' + copy(scontador, 5, 2);
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 6 do sContador := sContador + ' ';
        iRetorno := ECF_DataMovimento(sContador);

        ecfMSG := cECF_Analisa_Retorno(cod_ecf);

        if ecfMSG = OK then
        begin
          Result := copy(scontador, 1, 2) + '/' +
            copy(scontador, 3, 2) + '/' +
            '20' + copy(scontador, 5, 2);
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 14);

          iRetorno := EPSON_Obter_Data_Hora_Jornada(pchar(sRet));

          if iRetorno = 0 then
            Result := copy(sRet, 1, 2) + '/' + copy(sRet, 3, 2)
              + '/' + copy(sRet, 5, 4)
          else
            Result := cECF_Analisa_Retorno(EPSON);

        end;
end;

// -------------------------------------------------------------------------- //
// Verificar se existe cupom fiscal aberto

function cECF_Cupom_Fiscal_Aberto(cod_ECF: integer): string;
var
  sValor: string;
  sRet: string;
  I: integer;
begin
  if COD_ECF = BEMATECH then
  begin
    i := 0;
    iRetorno := Bematech_FI_FlagsFiscais(i);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
      begin
        if i >= 128 then i := i - 128;
        if i >= 64 then i := i - 64;
        if i >= 32 then i := i - 32;
        if i >= 16 then i := i - 16;
        if i >= 8 then i := i - 8;
        if i = 1 then
          Result := 'SIM'
        else
        begin
          Result := 'NAO';
        end;
      end
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      SetLength(svalor, 2);
      iRetorno := Daruma_FI_StatusCupomFiscal(svalor);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
        begin
          if copy(sValor, 1, 1) = '1' then
            Result := 'SIM'
          else
            Result := 'NAO';
        end
        else
          Result := sRet;
      end
      else
        Result := ecfMsg;
    end
    else
      if COD_ECF = SWEDA then
      begin
        SetLength(svalor, 2);
        iRetorno := ECF_StatusCupomFiscal(svalor);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          if copy(sValor, 1, 1) = '1' then
            Result := 'SIM'
          else
            Result := 'NAO';
        end
        else
          Result := ecfMsg;
      end
      else
        if COD_ECF = EPSON then
        begin
          if EPSON_CupomFiscalAberto then
            Result := 'SIM'
          else
            Result := 'NAO';
        end;

end;

// -------------------------------------------------------------------------- //
// Retorna o totalizador geral

function cECF_Grande_Total(cod_ECF: integer): string;
var
  sContador, sRet: string;
  i: integer;
  rvalor: real;

begin
  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 18 do sContador := sContador + ' ';
    iRetorno := Bematech_FI_GrandeTotal(sContador);

    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
      begin

        rvalor := strtofloat(scontador);
        if rvalor > 0 then
          Result := floattostr(rvalor / 100)
        else
          Result := '0';

      end
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 18 do sContador := sContador + ' ';
      iRetorno := Daruma_FI_GrandeTotal(sContador);

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
        begin
          rvalor := strtofloat(sContador);
          if rvalor > 0 then
            Result := floattostr(rvalor / 100)
          else
            Result := '0';
        end
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 18 do sContador := sContador + ' ';
        iRetorno := ECF_GrandeTotal(sContador);

        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
          begin

            rvalor := strtofloat(scontador);
            if rvalor > 0 then
              Result := floattostr(rvalor / 100)
            else
              Result := '0';

          end
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sContador, 18);

          iRetorno := EPSON_Obter_GT(pchar(sContador));

          if iRetorno = 0 then
          begin
            rValor := StrToFloat(sContador);
            if rValor > 0 then
              Result := FloatToStr(rValor / 100)
            else
              Result := '0';
          end
          else
            Result := ERRO;

        end;
end;


// -------------------------------------------------------------------------- //
// Informacoes referente a ultima reducao Z
// Contador de Reducoes impresso na ultima reducao z

function cECF_ReducaoZ_Contador_CRZ(COD_ECF: integer): string;
var
  sContador, sRet: string;
  i: integer;

begin
  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 1278 do sContador := sContador + ' ';
    iRetorno := Bematech_FI_DadosUltimaReducaoMFD(sContador);

    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := copy(somenteNumero(sContador), 7, 4)
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 4 do sContador := sContador + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('24', sContador);

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := sContador
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 1278 do sContador := sContador + ' ';
        iRetorno := ECF_DadosUltimaReducaoMFD(pchar(sContador));

        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := copy(somenteNumero(sContador), 7, 4)
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 1167);

          iRetorno := EPSON_Obter_Dados_Ultima_RZ(PChar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := copy(sRet, 27, 6);

        end;
end;

// -------------------------------------------------------------------------- //
// Contador de COO impresso na ultima reducao z

function cECF_ReducaoZ_Contador_COO(COD_ECF: integer): string;
var
  sContador, sRet: string;
  i: integer;
begin

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 1278 do sContador := sContador + ' ';
    iRetorno := Bematech_FI_DadosUltimaReducaoMFD(sContador);

    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := copy(somenteNumero(sContador), 11, 6)
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 1164 do sContador := sContador + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('140', sContador);

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := copy(sContador, 935, 6)
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 1278 do sContador := sContador + ' ';
        iRetorno := ecf_DadosUltimaReducaoMFD(PCHAR(sContador));

        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := copy(somenteNumero(sContador), 11, 6)
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;

      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 1167);

          iRetorno := EPSON_Obter_Dados_Ultima_RZ(PChar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := copy(sRet, 21, 6);

        end;
end;

// -------------------------------------------------------------------------- //
// Contador de CRO (REINICIO DE OPERACOES) impresso na ultima reducao z

function cECF_ReducaoZ_Contador_CRO(COD_ECF: integer): string;
var
  sContador, sRet: string;
  i: Integer;
begin

  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 1278 do sContador := sContador + ' ';
    iRetorno := Bematech_FI_DadosUltimaReducaoMFD(sContador);

    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := copy(somenteNumero(sContador), 3, 4)
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 3 do sContador := sContador + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('23', sContador);

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := SContador
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 1278 do sContador := sContador + ' ';
        iRetorno := ECF_DadosUltimaReducaoMFD(pchar(sContador));

        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := copy(somenteNumero(sContador), 3, 4)
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 1167);

          iRetorno := EPSON_Obter_Dados_Ultima_RZ(PChar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := copy(sRet, 33, 6);

        end;
end;

// -------------------------------------------------------------------------- //
// DATA E HORA da emissao da ultima reducao z

function cECF_ReducaoZ_DataHora(COD_ECF: integer): string;
var
  sHora,
    sData,
    sRet: string;
  I: integer;

begin
  if COD_ECF = BEMATECH then
  begin
    SetLength(SData, 6);
    SetLength(SHora, 6);
    IRetorno := Bematech_FI_DataHoraReducao(SData, SHora);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
        Result := sData + ' ' + sHora
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      SetLength(SData, 6);
      SetLength(SHora, 6);
      IRetorno := Daruma_FI_DataHoraReducao(SData, SHora);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
          Result := sData + ' ' + sHora
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        SetLength(SData, 6);
        SetLength(SHora, 6);
        IRetorno := ECF_DataHoraReducao(SData, SHora);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
            Result := sData + ' ' + sHora
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 1167);

          iRetorno := EPSON_Obter_Dados_Ultima_RZ(pchar(sRet));

          if iRetorno = 0 then
          begin
            sData := copy(sRet, 1, 8);
            sHora := copy(sRet, 9, 6);

            Result := sData + ' ' + sHora;
          end
          else
            Result := cECF_Analisa_Retorno(EPSON);
        end;
end;

// -------------------------------------------------------------------------- //
// DATA do movimento da ultima reducao z

function cECF_ReducaoZ_Data_Movimento(COD_ECF: integer): string;
var
  sContador,
    sRet: string;
  I: integer;
  sData: string;

begin
  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 1278 do sContador := sContador + ' ';
    iRetorno := Bematech_FI_DadosUltimaReducaoMFD(sContador);

    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
      begin
        sRet := copy(somenteNumero(sContador), 1237, 6);
        if sret = '000000' then
        // caso o ecf retorne a data zerada, informar a data do sistema
          Result := copy(DateToStr(dData_Sistema), 1, 2) +
            copy(DateToStr(dData_Sistema), 4, 2) +
            copy(DateToStr(dData_Sistema), 9, 2)
        else
          Result := copy(sRet, 1, 4) + '20' + copy(sRet, 5, 2);
      end
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 1164 do sContador := sContador + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('140', sContador);

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);

      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
        begin
          if sret = '00000000' then
            Result := copy(DateToStr(dData_Sistema), 1, 2) +
              copy(DateToStr(dData_Sistema), 4, 2) +
              copy(DateToStr(dData_Sistema), 7, 4)
          else
            Result := copy(sContador, 1, 8);
        end
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 1278 do sContador := sContador + ' ';
        iRetorno := ECF_DadosUltimaReducaoMFD(pchar(sContador));

        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
          begin
            sRet := copy(somenteNumero(sContador), 1237, 6);

            if sret = '000000' then
        // caso o ecf retorne a data zerada, informar a data do sistema
              Result := copy(DateToStr(dData_Sistema), 1, 2) +
                copy(DateToStr(dData_Sistema), 4, 2) +
                copy(DateToStr(dData_Sistema), 9, 2)
            else
              Result := copy(sRet, 1, 4) + '20' + copy(sRet, 5, 2);

          end
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 1167);

          iRetorno := EPSON_Obter_Dados_Ultima_RZ(pchar(sRet));

          if iRetorno = 0 then
          begin
            sData := copy(sRet, 1160, 8);

      // caso o ecf retorne a data zerada, informar a data do sistema
            if (trim(sData) = '') or (copy(trim(sData), 1, 2) = '00') then
            begin
              sData := FormatDateTime('ddmmyyyy', dData_Sistema);
            end;

            Result := sData;
          end
          else
            Result := cECF_Analisa_Retorno(EPSON);
        end;
end;

// -------------------------------------------------------------------------- //
// valor da venda bruta da ultima reducao z

function cECF_ReducaoZ_Venda_Bruta(COD_ECF: integer): string;
var
  sContador, sRet: string;
  i: integer;
  txt: textfile;
  sVendaBrutaAtual: string;
  sVendaBrutaAnterior: string;

begin
  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_MapaResumoMFD();

    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
      begin
        if FileExists(SystemDrive + '\Retorno.txt') then
        begin
          sret := '0';
          assignfile(txt, SystemDrive + '\Retorno.txt');
          reset(txt);
          while not eof(txt) do
          begin
            readln(txt, sRet);
            if copy(sRet, 1, 10) = 'Venda Brut' then
            begin
              sRet := somenteNumero(copy(sRet, 34, 16));
              break;
            end;
          end;
          closefile(txt);
          sRet := FLOATTOSTR(STRTOFLOAT(sRet));
          if sRet <> '0' then
            sRet := floattostr(strtofloat(sret) / 100);
          Result := sRet;
        end
        else
          Result := 'Arquivo ' + SystemDrive + '\Retorno.txt n�o encontrado!';
      end
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 1164 do sContador := sContador + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('140', sContador);

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
        begin
        // Pegar o Totalizador Geral Atual - Totalizador Geral Inicial
          sRet := FLOATTOSTR(STRTOFLOAT(COPY(sContador, 9, 18)) - STRTOFLOAT(COPY(sContador, 27, 18)));
          if sRet <> '0' then
            sRet := floattostr(strtofloat(sret) / 100);
          Result := sRet;
        end
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_MapaResumoMFD();

        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
          begin
            if FileExists(SystemDrive + '\Retorno.txt') then
            begin
              sret := '0';
              assignfile(txt, SystemDrive + '\Retorno.txt');
              reset(txt);
              while not eof(txt) do
              begin
                readln(txt, sRet);
                if copy(sRet, 1, 10) = 'Venda Brut' then
                begin
                  sRet := somenteNumero(copy(sRet, 45, 16));
                  break;
                end;
              end;
              closefile(txt);
              sRet := FLOATTOSTR(STRTOFLOAT(sRet));
              if sRet <> '0' then
                sRet := floattostr(strtofloat(sret) / 100);
              Result := sRet;
            end
            else
              Result := 'Arquivo ' + SystemDrive + ' Retorno.txt n�o encontrado!';
          end
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sVendaBrutaAtual, 15);
          SetLength(sVendaBrutaAnterior, 15);

          iRetorno := EPSON_Obter_Venda_Bruta(pchar(sVendaBrutaAtual),
            pchar(sVendaBrutaAnterior));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := FloatToStr((StrToFloat(sVendaBrutaAtual) / 100));

        end;
end;

// -------------------------------------------------------------------------- //
// total do iss da ultima reducao z

function cECF_ReducaoZ_Total_ISS(COD_ECF: integer): string;
var
  sContador, sRet: string;
  i: integer;
  txt: textfile;
  sReducaoZ: string;
  rISS: Currency;
  sAliquota: string;
  sValor: string;

begin
  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_MapaResumoMFD();

    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
      begin
        if FileExists(SystemDrive + '\Retorno.txt') then
        begin
          sret := '0';
          assignfile(txt, SystemDrive + '\Retorno.txt');
          reset(txt);
          while not eof(txt) do
          begin
            readln(txt, sRet);
            if copy(sRet, 1, 3) = 'ISS' then
            begin
              sRet := somenteNumero(copy(sRet, 34, 16));
              break;
            end;
          end;
          closefile(txt);
          sRet := FLOATTOSTR(STRTOFLOAT(sRet));
          if sRet <> '0' then
            sRet := floattostr(strtofloat(sret) / 100);
          Result := sRet;
        end
        else
          Result := 'Arquivo ' + SystemDrive + ' Retorno.txt n�o encontrado!';
      end
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_MapaResumo();

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);

      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);

        if sRet = OK then
        begin
          if FileExists(SystemDrive + '\Retorno.txt') then
          begin
            sret := '0';
            assignfile(txt, SystemDrive + '\Retorno.txt');
            reset(txt);

            while not eof(txt) do
            begin
              readln(txt, sRet);
              if copy(sRet, 1, 3) = 'ISS' then
              begin
                sRet := somenteNumero(copy(sRet, 25, 16));
                break;
              end;
            end;

            closefile(txt);
            sRet := FLOATTOSTR(STRTOFLOAT(sRet));

            if sRet <> '0' then
              sRet := floattostr(strtofloat(sret) / 100);

            Result := sRet;
          end
          else
            Result := 'Arquivo ' + SystemDrive + ' Retorno.txt n�o encontrado!';
        end
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ecf_MapaResumoMFD();

        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
          begin
            if FileExists(SystemDrive + '\Retorno.txt') then
            begin
              sret := '0';
              assignfile(txt, SystemDrive + ' Retorno.txt');
              reset(txt);
              while not eof(txt) do
              begin
                readln(txt, sRet);
                if copy(sRet, 1, 3) = 'ISS' then
                begin
                  sRet := somenteNumero(copy(sRet, 45, 16));
                  break;
                end;
              end;
              closefile(txt);
              sRet := FLOATTOSTR(STRTOFLOAT(sRet));
              if sRet <> '0' then
                sRet := floattostr(strtofloat(sret) / 100);
              Result := sRet;
            end
            else
              Result := 'Arquivo c:\Retorno.txt n�o encontrado!';
          end
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
    {ReducaoZ := cECF_ReducaoZ_Contador_COO(EPSON);

    SetLength(sRet, 602);

    // GUIO: O copy abaixo � para poder pegar apenas 4 d�gitos do n�mero da redu��o
    // pois o parametro pede 4 digitos, por�m o retorno da fun��o cECF_Reducao_Z_Contador_COO
    // retorna 6 digitos
    iRetorno := EPSON_Obter_Total_JornadaEX('I', pchar(copy(sReducaoZ, 3,4)),
      PChar(sRet));

    if iRetorno <> 0 then
      Result := cECF_Analisa_Retorno(EPSON)
    else
      Result := FloatToStr((StrToFloat(copy(sRet, 239, 13))/100));}

          rISS := 0.00;

          for i := 1 to 1167 do
            sRet := sRet + ' ';

          iRetorno := EPSON_Obter_Dados_Ultima_RZ(PChar(sRet));

          if iRetorno <> 0 then
          begin
            Result := cECF_Analisa_Retorno(EPSON);
          end
          else
          begin
            sAliquota := copy(sRet, 258, 120);
            sValor := copy(sRet, 384, 408);
            I := 1;

      // GUIO: Totalizadores Fiscais buscando apenas ISS
            while (trim(sAliquota) <> '') do
            begin
              if copy(sAliquota, 1, 1) = 'S' then
                rISS := rISS + (StrToFloat(copy(sValor, 1, 17)) / 100);

              sAliquota := copy(sAliquota, 6, length(sAliquota));
              sValor := copy(sValor, 18, length(sValor));
            end;

            Result := FloatToStr(rISS);
          end;
        end;
end;

// -------------------------------------------------------------------------- //
// totalizador geral da ultima reducao z

function cECF_ReducaoZ_Totalizador_Geral(COD_ECF: integer): string;
var
  sContador, sRet: string;
  i: integer;
  rvalor: real;

begin
  if COD_ECF = BEMATECH then
  begin
    for i := 1 to 1278 do sContador := sContador + ' ';
    iRetorno := Bematech_FI_DadosUltimaReducaoMFD(sContador);

    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
      begin

        rvalor := strtofloat(copy(somenteNumero(sContador), 301, 18));
        if rvalor > 0 then
          Result := floattostr(rvalor / 100)
        else
          Result := '0';

      end
      else
        Result := sRet;
    end
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 1164 do sContador := sContador + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('140', sContador);

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);
        if sRet = OK then
        begin
          rvalor := strtofloat(copy(sContador, 9, 18));
          if rvalor > 0 then
            Result := floattostr(rvalor / 100)
          else
            Result := '0';
        end
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        for i := 1 to 1278 do sContador := sContador + ' ';
        iRetorno := ecf_DadosUltimaReducaoMFD(pchar(sContador));

        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
          begin

            rvalor := strtofloat(copy(somenteNumero(sContador), 301, 18));
            if rvalor > 0 then
              Result := floattostr(rvalor / 100)
            else
              Result := '0';

          end
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sRet, 1167);

          iRetorno := EPSON_Obter_Dados_Ultima_RZ(PChar(sRet));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := FloatToStr((StrToFloat(copy(sRet, 87, 18)) / 100));
        end;
end;

// -------------------------------------------------------------------------- //
// totalizadores parciais da ultima reducao z

function cECF_ReducaoZ_Totalizador_Parcial(COD_ECF: Integer): string;
var
  sRet: string;
  i, x, Y, w: integer;
  sTotalizador, svalor, sTexto: string;
  sAliquota, sIss: string;
  rSoma: real;
  iPosNome: Integer;
  iPosValor: Integer;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    // LER A RELACAO DE ALIQUOTAS DE ISS
    for i := 1 to 79 do sISS := sIss + ' ';
    iRetorno := Bematech_FI_VerificaAliquotasIss(sIss);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
    begin
      sRet := cECF_Retorno_Impressora(cod_ecf);
      if sRet = OK then
      begin
        for i := 1 to 1278 do sTotalizador := sTotalizador + ' ';
        iRetorno := Bematech_FI_DadosUltimaReducaoMFD(sTotalizador);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
          begin
            sTotalizador := somentenumero(sTotalizador);
            sAliquota := copy(sTotalizador, 1173, 64);
            sValor := copy(sTotalizador, 319, 224);


            X := 1;
            w := 1;
            // rodar as 16 posicoes de aliquotas e alimentar o Array
            for i := 1 to 16 do
            begin
              sTexto := copy(sAliquota, X, 4);
              // Aliquota de Icms Tributado valido
              if sTexto <> '0000' then
              begin
                if pos(sTexto, sIss) = 0 then
                begin
                  sTexto := Zerar(IntToStr(i), 2) + 'T' + sTexto;
                end
                else
                begin
                  sTexto := Zerar(IntToStr(i), 2) + 'S' + sTexto;
                end;
              end;
              TbTotalizador[i].Nome := sTexto;

              sTexto := floattostr(strtofloat(copy(sValor, w, 14)));
              if strtofloat(sTexto) > 0 then
                sTexto := floattostr(strtofloat(sTexto) / 100);

              tbTotalizador[i].valor := strtofloat(sTexto);
              X := X + 4;
              w := w + 14;
            end;

            // copiar a aliquota de substituicao tributaria

            sTexto := floattostr(strtofloat(copy(sTotalizador, 571, 14)));
            if strtofloat(sTexto) > 0 then
              sTexto := floattostr(strtofloat(sTexto) / 100);
            TbTotalizador[i].Nome := 'F1';
            TbTotalizador[i].valor := StrToFloat(sTexto);

            i := i + 1;
            TbTotalizador[i].Nome := 'F2';
            TbTotalizador[i].valor := 0;

            // copiar a aliquota Isento
            i := i + 1;
            sTexto := floattostr(strtofloat(copy(sTotalizador, 543, 14)));
            if strtofloat(sTexto) > 0 then
              sTexto := floattostr(strtofloat(sTexto) / 100);
            TbTotalizador[i].Nome := 'I1';
            TbTotalizador[i].valor := StrToFloat(sTexto);

            i := i + 1;
            TbTotalizador[i].Nome := 'I2';
            TbTotalizador[i].valor := 0;


            // copiar a aliquota Nao Tributado
            i := i + 1;
            sTexto := floattostr(strtofloat(copy(sTotalizador, 557, 14)));
            if strtofloat(sTexto) > 0 then
              sTexto := floattostr(strtofloat(sTexto) / 100);
            TbTotalizador[i].Nome := 'N1';
            TbTotalizador[i].valor := StrToFloat(sTexto);

            i := i + 1;
            TbTotalizador[i].Nome := 'N2';
            TbTotalizador[i].valor := 0;

            //----- I S S Q N


            // copiar a aliquota de substituicao tributaria

            sTexto := floattostr(strtofloat(copy(sTotalizador, 613, 14)));
            if strtofloat(sTexto) > 0 then
              sTexto := floattostr(strtofloat(sTexto) / 100);
            TbTotalizador[i].Nome := 'FS1';
            TbTotalizador[i].valor := StrToFloat(sTexto);

            i := i + 1;
            TbTotalizador[i].Nome := 'FS2';
            TbTotalizador[i].valor := 0;

            // copiar a aliquota Isento
            i := i + 1;
            sTexto := floattostr(strtofloat(copy(sTotalizador, 585, 14)));
            if strtofloat(sTexto) > 0 then
              sTexto := floattostr(strtofloat(sTexto) / 100);
            TbTotalizador[i].Nome := 'IS1';
            TbTotalizador[i].valor := StrToFloat(sTexto);

            i := i + 1;
            TbTotalizador[i].Nome := 'IS2';
            TbTotalizador[i].valor := 0;


            // copiar a aliquota Nao Tributado
            i := i + 1;
            sTexto := floattostr(strtofloat(copy(sTotalizador, 599, 14)));
            if strtofloat(sTexto) > 0 then
              sTexto := floattostr(strtofloat(sTexto) / 100);
            TbTotalizador[i].Nome := 'NS1';
            TbTotalizador[i].valor := StrToFloat(sTexto);

            i := i + 1;
            TbTotalizador[i].Nome := 'NS2';
            TbTotalizador[i].valor := 0;

            // N A O   F I S C A L
            i := i + 1;
            rSoma := 0;
            x := 711;
            for w := 1 to 28 do
            begin
              rSoma := rSoma + strtofloat(copy(sTotalizador, x, 14));
              x := x + 14;
            end;
            // sangria +
            rSoma := rSoma + strtofloat(copy(sTotalizador, 1103, 14));
            // suprimento +
            rSoma := rSoma + strtofloat(copy(sTotalizador, 1117, 14));

            if rsoma > 0 then rsoma := rsoma / 100;
            TbTotalizador[i].Nome := 'OPNF';
            TbTotalizador[i].valor := rSoma;

            // Desconto ICMS
            i := i + 1;
            sTexto := floattostr(strtofloat(copy(sTotalizador, 627, 14)));
            if strtofloat(sTexto) > 0 then
              sTexto := floattostr(strtofloat(sTexto) / 100);
            TbTotalizador[i].Nome := 'DT';
            TbTotalizador[i].valor := StrToFloat(sTexto);

            // Desconto ISS
            i := i + 1;
            sTexto := floattostr(strtofloat(copy(sTotalizador, 641, 14)));
            if strtofloat(sTexto) > 0 then
              sTexto := floattostr(strtofloat(sTexto) / 100);
            TbTotalizador[i].Nome := 'DS';
            TbTotalizador[i].valor := StrToFloat(sTexto);


            // Acrescimo ICMS
            i := i + 1;
            sTexto := floattostr(strtofloat(copy(sTotalizador, 655, 14)));
            if strtofloat(sTexto) > 0 then
              sTexto := floattostr(strtofloat(sTexto) / 100);
            TbTotalizador[i].Nome := 'AT';
            TbTotalizador[i].valor := StrToFloat(sTexto);

            // Acrescimo ISS
            i := i + 1;
            sTexto := floattostr(strtofloat(copy(sTotalizador, 669, 14)));
            if strtofloat(sTexto) > 0 then
              sTexto := floattostr(strtofloat(sTexto) / 100);
            TbTotalizador[i].Nome := 'AS';
            TbTotalizador[i].valor := StrToFloat(sTexto);


            // CAncelamento ICMS
            i := i + 1;
            sTexto := floattostr(strtofloat(copy(sTotalizador, 683, 14)));
            if strtofloat(sTexto) > 0 then
              sTexto := floattostr(strtofloat(sTexto) / 100);
            TbTotalizador[i].Nome := 'Can-T';
            TbTotalizador[i].valor := StrToFloat(sTexto);

            // Cancelamento ISS
            i := i + 1;
            sTexto := floattostr(strtofloat(copy(sTotalizador, 697, 14)));
            if strtofloat(sTexto) > 0 then
              sTexto := floattostr(strtofloat(sTexto) / 100);
            TbTotalizador[i].Nome := 'Can-S';
            TbTotalizador[i].valor := StrToFloat(sTexto);

            Result := OK;
          end
          else
            Result := sRet;

        end
        else
          Result := ecfMSG;

      end
      else
        Result := sRet;

    end
    else
      Result := ecfMSG;

  end
  else
    if COD_ECF = DARUMA then
    begin
      for i := 1 to 1164 do sTotalizador := sTotalizador + ' ';
      iRetorno := Daruma_FIMFD_RetornaInformacao('140', sTotalizador);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        sRet := cECF_Retorno_Impressora(cod_ecf);

        if sRet = OK then
        begin
          sAliquota := copy(sTotalizador, 843, 80);
          sValor := copy(sTotalizador, 129, 224);

          X := 1;
          w := 1;

        // rodar as 16 posicoes de aliquotas e alimentar o Array
          for i := 1 to 16 do
          begin
            sTexto := copy(sAliquota, X, 5);
          // Aliquota de Icms Tributado valido
            if copy(sTexto, 1, 1) = '1' then
            begin
              sTexto := Zerar(IntToStr(i), 2) + 'T' + copy(sTexto, 2, 4);
            end;
          // Aliquota de ISS Tributado valido
            if copy(sTexto, 1, 1) = '2' then
            begin
              sTexto := Zerar(IntToStr(i), 2) + 'S' + copy(sTexto, 2, 4);
            end;
            TbTotalizador[i].Nome := sTexto;

            sTexto := floattostr(strtofloat(copy(sValor, w, 14)));
            if strtofloat(sTexto) > 0 then
              sTexto := floattostr(strtofloat(sTexto) / 100);

            tbTotalizador[i].valor := strtofloat(sTexto);
            X := X + 5;
            w := w + 14;
          end;

        // copiar a aliquota de substituicao tributaria
          sTexto := floattostr(strtofloat(copy(sTotalizador, 353, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'F1';
          TbTotalizador[i].valor := StrToFloat(sTexto);

          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 367, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'F2';
          TbTotalizador[i].valor := StrToFloat(sTexto);

        // copiar a aliquota Isento
          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 381, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'I1';
          TbTotalizador[i].valor := StrToFloat(sTexto);

          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 395, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'I2';
          TbTotalizador[i].valor := StrToFloat(sTexto);

        // copiar a aliquota Nao Tributado
          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 409, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'N1';
          TbTotalizador[i].valor := StrToFloat(sTexto);

          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 423, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'N2';
          TbTotalizador[i].valor := StrToFloat(sTexto);

        //----- I S S Q N

        // copiar a aliquota de substituicao tributaria

          sTexto := floattostr(strtofloat(copy(sTotalizador, 437, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'FS1';
          TbTotalizador[i].valor := StrToFloat(sTexto);

          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 451, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'FS2';
          TbTotalizador[i].valor := StrToFloat(sTexto);

        // copiar a aliquota Isento
          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 465, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'IS1';
          TbTotalizador[i].valor := StrToFloat(sTexto);

          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 479, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'IS2';
          TbTotalizador[i].valor := StrToFloat(sTexto);

        // copiar a aliquota Nao Tributado
          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 493, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'NS1';
          TbTotalizador[i].valor := StrToFloat(sTexto);

          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 507, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'NS2';
          TbTotalizador[i].valor := StrToFloat(sTexto);

        // N A O   F I S C A L
          i := i + 1;
          rSoma := 0;
          x := 521;
          for w := 1 to 20 do
          begin
            rSoma := rSoma + strtofloat(copy(sTotalizador, x, 14));
            x := x + 14;
          end;
          if rsoma > 0 then rsoma := rsoma / 100;
          TbTotalizador[i].Nome := 'OPNF';
          TbTotalizador[i].valor := rSoma;

        // Desconto ICMS
          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 45, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'DT';
          TbTotalizador[i].valor := StrToFloat(sTexto);

        // Desconto ISS
          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 59, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'DS';
          TbTotalizador[i].valor := StrToFloat(sTexto);


        // Acrescimo ICMS
          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 101, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'AT';
          TbTotalizador[i].valor := StrToFloat(sTexto);

        // Acrescimo ISS
          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 115, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'AS';
          TbTotalizador[i].valor := StrToFloat(sTexto);

        // CAncelamento ICMS
          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 73, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'Can-T';
          TbTotalizador[i].valor := StrToFloat(sTexto);

        // Cancelamento ISS
          i := i + 1;
          sTexto := floattostr(strtofloat(copy(sTotalizador, 87, 14)));
          if strtofloat(sTexto) > 0 then
            sTexto := floattostr(strtofloat(sTexto) / 100);
          TbTotalizador[i].Nome := 'Can-S';
          TbTotalizador[i].valor := StrToFloat(sTexto);


          Result := OK;
        end
        else
          Result := sRet;
      end
      else
        Result := ecfMSG;

    end
    else
      if COD_ECF = SWEDA then
      begin
    // LER A RELACAO DE ALIQUOTAS DE ISS
        for i := 1 to 79 do sISS := sIss + ' ';
        iRetorno := ecf_VerificaAliquotasIss(sIss);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          sRet := cECF_Retorno_Impressora(cod_ecf);
          if sRet = OK then
          begin
            for i := 1 to 1278 do sTotalizador := sTotalizador + ' ';
            iRetorno := ECF_DadosUltimaReducaoMFD(pchar(sTotalizador));
            ecfMSG := cECF_Analisa_Retorno(cod_ecf);
            if ecfMSG = OK then
            begin
              sRet := cECF_Retorno_Impressora(cod_ecf);
              if sRet = OK then
              begin
                sTotalizador := somentenumero(sTotalizador);
                sAliquota := copy(sTotalizador, 1173, 64);
                sValor := copy(sTotalizador, 319, 224);


                X := 1;
                w := 1;
            // rodar as 16 posicoes de aliquotas e alimentar o Array
                for i := 1 to 16 do
                begin
                  sTexto := copy(sAliquota, X, 4);
              // Aliquota de Icms Tributado valido
                  if sTexto <> '0000' then
                  begin
                    if pos(sTexto, sIss) = 0 then
                    begin
                      sTexto := Zerar(IntToStr(i), 2) + 'T' + sTexto;
                    end
                    else
                    begin
                      sTexto := Zerar(IntToStr(i), 2) + 'S' + sTexto;
                    end;
                  end;
                  TbTotalizador[i].Nome := sTexto;

                  sTexto := floattostr(strtofloat(copy(sValor, w, 14)));
                  if strtofloat(sTexto) > 0 then
                    sTexto := floattostr(strtofloat(sTexto) / 100);

                  tbTotalizador[i].valor := strtofloat(sTexto);
                  X := X + 4;
                  w := w + 14;
                end;


            // copiar a aliquota de substituicao tributaria

                sTexto := floattostr(strtofloat(copy(sTotalizador, 571, 14)));
                if strtofloat(sTexto) > 0 then
                  sTexto := floattostr(strtofloat(sTexto) / 100);
                TbTotalizador[i].Nome := 'F1';
                TbTotalizador[i].valor := StrToFloat(sTexto);

                i := i + 1;
                TbTotalizador[i].Nome := 'F2';
                TbTotalizador[i].valor := 0;

            // copiar a aliquota Isento
                i := i + 1;
                sTexto := floattostr(strtofloat(copy(sTotalizador, 543, 14)));
                if strtofloat(sTexto) > 0 then
                  sTexto := floattostr(strtofloat(sTexto) / 100);
                TbTotalizador[i].Nome := 'I1';
                TbTotalizador[i].valor := StrToFloat(sTexto);

                i := i + 1;
                TbTotalizador[i].Nome := 'I2';
                TbTotalizador[i].valor := 0;

            // copiar a aliquota Nao Tributado
                i := i + 1;
                sTexto := floattostr(strtofloat(copy(sTotalizador, 557, 14)));
                if strtofloat(sTexto) > 0 then
                  sTexto := floattostr(strtofloat(sTexto) / 100);
                TbTotalizador[i].Nome := 'N1';
                TbTotalizador[i].valor := StrToFloat(sTexto);

                i := i + 1;
                TbTotalizador[i].Nome := 'N2';
                TbTotalizador[i].valor := 0;


            //----- I S S Q N


            // copiar a aliquota de substituicao tributaria

                sTexto := floattostr(strtofloat(copy(sTotalizador, 613, 14)));
                if strtofloat(sTexto) > 0 then
                  sTexto := floattostr(strtofloat(sTexto) / 100);
                TbTotalizador[i].Nome := 'FS1';
                TbTotalizador[i].valor := StrToFloat(sTexto);

                i := i + 1;
                TbTotalizador[i].Nome := 'FS2';
                TbTotalizador[i].valor := 0;

            // copiar a aliquota Isento
                i := i + 1;
                sTexto := floattostr(strtofloat(copy(sTotalizador, 585, 14)));
                if strtofloat(sTexto) > 0 then
                  sTexto := floattostr(strtofloat(sTexto) / 100);
                TbTotalizador[i].Nome := 'IS1';
                TbTotalizador[i].valor := StrToFloat(sTexto);

                i := i + 1;
                TbTotalizador[i].Nome := 'IS2';
                TbTotalizador[i].valor := 0;


            // copiar a aliquota Nao Tributado
                i := i + 1;
                sTexto := floattostr(strtofloat(copy(sTotalizador, 599, 14)));
                if strtofloat(sTexto) > 0 then
                  sTexto := floattostr(strtofloat(sTexto) / 100);
                TbTotalizador[i].Nome := 'NS1';
                TbTotalizador[i].valor := StrToFloat(sTexto);

                i := i + 1;
                TbTotalizador[i].Nome := 'NS2';
                TbTotalizador[i].valor := 0;

            // N A O   F I S C A L
                i := i + 1;
                rSoma := 0;
                x := 711;
                for w := 1 to 28 do
                begin
                  rSoma := rSoma + strtofloat(copy(sTotalizador, x, 14));
                  x := x + 14;
                end;
            // sangria +
                rSoma := rSoma + strtofloat(copy(sTotalizador, 1103, 14));
            // suprimento +
                rSoma := rSoma + strtofloat(copy(sTotalizador, 1117, 14));

                if rsoma > 0 then rsoma := rsoma / 100;
                TbTotalizador[i].Nome := 'OPNF';
                TbTotalizador[i].valor := rSoma;

            // Desconto ICMS
                i := i + 1;
                sTexto := floattostr(strtofloat(copy(sTotalizador, 627, 14)));
                if strtofloat(sTexto) > 0 then
                  sTexto := floattostr(strtofloat(sTexto) / 100);
                TbTotalizador[i].Nome := 'DT';
                TbTotalizador[i].valor := StrToFloat(sTexto);

            // Desconto ISS
                i := i + 1;
                sTexto := floattostr(strtofloat(copy(sTotalizador, 641, 14)));
                if strtofloat(sTexto) > 0 then
                  sTexto := floattostr(strtofloat(sTexto) / 100);
                TbTotalizador[i].Nome := 'DS';
                TbTotalizador[i].valor := StrToFloat(sTexto);


            // Acrescimo ICMS
                i := i + 1;
                sTexto := floattostr(strtofloat(copy(sTotalizador, 655, 14)));
                if strtofloat(sTexto) > 0 then
                  sTexto := floattostr(strtofloat(sTexto) / 100);
                TbTotalizador[i].Nome := 'AT';
                TbTotalizador[i].valor := StrToFloat(sTexto);

            // Acrescimo ISS
                i := i + 1;
                sTexto := floattostr(strtofloat(copy(sTotalizador, 669, 14)));
                if strtofloat(sTexto) > 0 then
                  sTexto := floattostr(strtofloat(sTexto) / 100);
                TbTotalizador[i].Nome := 'AS';
                TbTotalizador[i].valor := StrToFloat(sTexto);


            // CAncelamento ICMS
                i := i + 1;
                sTexto := floattostr(strtofloat(copy(sTotalizador, 683, 14)));
                if strtofloat(sTexto) > 0 then
                  sTexto := floattostr(strtofloat(sTexto) / 100);
                TbTotalizador[i].Nome := 'Can-T';
                TbTotalizador[i].valor := StrToFloat(sTexto);

            // Cancelamento ISS
                i := i + 1;
                sTexto := floattostr(strtofloat(copy(sTotalizador, 697, 14)));
                if strtofloat(sTexto) > 0 then
                  sTexto := floattostr(strtofloat(sTexto) / 100);
                TbTotalizador[i].Nome := 'Can-S';
                TbTotalizador[i].valor := StrToFloat(sTexto);

                Result := OK;


              end
              else
                Result := sRet;
            end
            else
              Result := ecfMSG;
          end
          else
            Result := sRet;
        end
        else
          Result := ecfMSG;

      end
      else
        if COD_ECF = EPSON then
        begin
          for i := 1 to 1167 do
            sRet := sRet + ' ';

          iRetorno := EPSON_Obter_Dados_Ultima_RZ(PChar(sRet));

          if iRetorno <> 0 then
          begin
            Result := cECF_Analisa_Retorno(EPSON);
          end
          else
          begin
            sAliquota := copy(sRet, 258, 120);
            sValor := copy(sRet, 384, 408);
            I := 1;

      // GUIO: Totalizadores Fiscais
            while (trim(sAliquota) <> '') do
            begin
              TbTotalizador[I].Nome := copy(sAliquota, 1, 5);
              TbTotalizador[I].Valor := (StrToFloat(copy(sValor, 1, 17)) / 100);

              sAliquota := copy(sAliquota, 6, length(sAliquota));
              sValor := copy(sValor, 18, length(sValor));

              Inc(I);
            end;

      // GUIO: Totalizadores N�o Fiscais
            sValor := copy(sRet, 818, 340);
            rSoma := 0.00;

            while (trim(sValor) <> '') do
            begin
              rSoma := rSoma + StrToFloat(copy(sValor, 1, 13));
              sValor := copy(sValor, 18, length(sValor));
            end;

            if rSoma > 0.00 then
            begin
              TbTotalizador[I].Nome := 'OPNF';
              TbTotalizador[I].valor := (rSoma / 100);
              Inc(I);
            end;

      // GUIO: Desconto ICMS
            sValor := copy(sRet, 156, 17);

            TbTotalizador[I].Nome := 'DT';
            TbTotalizador[I].valor := (StrToFloat(sValor) / 100);
            Inc(I);

      // GUIO: Desconto ISS
            sValor := copy(sRet, 173, 17);

            TbTotalizador[I].Nome := 'DS';
            TbTotalizador[I].valor := (StrToFloat(sValor) / 100);
            Inc(I);

      // GUIO: Acr�scimo ICMS
            sValor := copy(sRet, 207, 17);

            TbTotalizador[I].Nome := 'AT';
            TbTotalizador[I].valor := (StrToFloat(sValor) / 100);
            Inc(I);

      // GUIO: Acr�scimo ISS
            sValor := copy(sRet, 224, 17);

            TbTotalizador[I].Nome := 'AS';
            TbTotalizador[I].valor := (StrToFloat(sValor) / 100);
            Inc(I);

      // GUIO: Cancelamento ICMS
            sValor := copy(sRet, 105, 17);

            TbTotalizador[I].Nome := 'Can-T';
            TbTotalizador[I].valor := (StrToFloat(sValor) / 100);
            Inc(I);

      // GUIO: Cancelamento ISS
            sValor := copy(sRet, 122, 17);

            TbTotalizador[I].Nome := 'Can-S';
            TbTotalizador[I].valor := (StrToFloat(sValor) / 100);
            Inc(I);

            Result := OK;
          end;
        end;
end;


// -------------------------------------------------------------------------- //
// LEITURA X

function cECF_LeituraX(COD_ECF: Integer): string;
begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_LeituraX();
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf) // retorna OK ou a Mensagem de Erro;
    else
      Result := ecfMSG; // retorna o Erro de falha de comunica��o com o ECF
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_LeituraX();
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_LeituraX();
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;

      end
      else
        if COD_ECF = EPSON then
        begin
          iRetorno := EPSON_RelatorioFiscal_Abrir_Dia();

    // CGT: Se houve falha na abertura do dia, executa apenas a leitura X
          if iRetorno <> 0 then
            iRetorno := EPSON_RelatorioFiscal_LeituraX();

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end
end;

// -------------------------------------------------------------------------- //
// REDUCAO Z

function cECF_ReducaoZ(COD_ECF: Integer): string;
var
  sCRZ: string;

begin
  Result := ERRO;
  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_ReducaoZ(pchar(''), pchar(''));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_ReducaoZ(pchar(''), pchar(''));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_ReducaoZ(pchar(''), pchar(''));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          SetLength(sCRZ, 4);
          iRetorno := EPSON_RelatorioFiscal_RZ('', '', 2, PChar(sCRZ));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end
end;

// -------------------------------------------------------------------------- //

function cECF_Leitura_Memoria_Fiscal(COD_ECF: INTEGER;
  Tipo: string; // DATA ou CRZ
  Analitica_ou_Sintetica: string; // A ou S
  Ecf_ou_Arquivo: string; // ECF ou ARQUIVO
  Inicio: string; Fim: string): string;
var
  stipo: string;
  sDados: string;
  iTipo: Integer;
  sArq: string;
  iBuffer: Integer;

begin
  stipo := AnsiLowerCase(Analitica_ou_Sintetica);

  if tipo = 'DATA' then
  begin
    Result := ERRO;

    if COD_ECF = BEMATECH then
    begin
      if stipo = 'a' then stipo := 'c';

      if Ecf_ou_Arquivo = 'ECF' then
        iRetorno := Bematech_FI_LeituraMemoriaFiscalDataMFD(pchar(Inicio), pchar(Fim), pchar(stipo))
      else
        iRetorno := Bematech_FI_LeituraMemoriaFiscalSerialDataMFD(pchar(Inicio), pchar(Fim), pchar(stipo));

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = DARUMA then
      begin
        if Analitica_ou_Sintetica = 'A' then
          Daruma_Registry_MFD_LeituraMFCompleta('1') // analitica
        else
          Daruma_Registry_MFD_LeituraMFCompleta('0'); // sintetica


        if Ecf_ou_Arquivo = 'ECF' then
          iRetorno := Daruma_FI_LeituraMemoriaFiscalData(pchar(Inicio), pchar(Fim))
        else
          iRetorno := Daruma_FI_LeituraMemoriaFiscalSerialData(pchar(Inicio), pchar(Fim));

        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
        begin
          Result := cECF_Retorno_Impressora(cod_ecf);
        end
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = SWEDA then
        begin
          if stipo = 'a' then stipo := 'c';

          if Ecf_ou_Arquivo = 'ECF' then
            iRetorno := ECF_LeituraMemoriaFiscalDataMFD(pchar(Inicio), pchar(Fim), pchar(stipo))
          else
            iRetorno := ECF_LeituraMemoriaFiscalSerialDataMFD(pchar(Inicio), pchar(Fim), pchar(stipo));

          ecfMSG := cECF_Analisa_Retorno(cod_ecf);
          if ecfMSG = OK then
            Result := cECF_Retorno_Impressora(cod_ecf)
          else
            Result := ecfMSG;
        end
        else
          if COD_ECF = EPSON then
          begin
      // CGT: Desabilita a assinatura digital do Arquivo
            iRetorno := EPSON_Config_Habilita_EAD(false);
            iBuffer := 0;
            sArq := '';

            SetLength(sDados, 10000);

            if Analitica_ou_Sintetica = 'A' then
              iTipo := 1 // Completo por Data
            else
              iTipo := 3; // Simplificado por Data

      // GUIO: Caso seja por data, faz a valida��o das datas
            if (iTipo = 1) or (iTipo = 2) then
            begin
              try
                inicio := FormatDateTime('ddmmyyyy', StrToDate(inicio));
              except
                Result := 'Data inicial inv�lida!';
                Exit;
              end;

              try
                fim := FormatDateTime('ddmmyyyy', StrToDate(fim));
              except
                Result := 'Data final inv�lida!';
                Exit;
              end;
            end;

            if Ecf_ou_Arquivo = 'ECF' then
              Inc(iTipo, 4) // Imprimi no ECF
            else
            begin
              Inc(iTipo, 16); // Grava em Arquivo
              sArq := SystemDrive + '\Retorno.txt';
            end;

            if sArq <> '' then
              iRetorno := EPSON_RelatorioFiscal_Leitura_MF(pchar(inicio),
                pchar(fim), iTipo, PChar(sDados), pchar(sArq), @iBuffer, 10000)
            else
              iRetorno := EPSON_RelatorioFiscal_Leitura_MF(pchar(inicio),
                pchar(fim), iTipo, PChar(sDados), '', @iBuffer, 10000);

            if iRetorno <> 0 then
              Result := cECF_Analisa_Retorno(EPSON)
            else
              Result := OK;

          end
  end
  else
  begin
    Result := ERRO;

    if COD_ECF = BEMATECH then
    begin
      if stipo = 'a' then stipo := 'c';
      if Ecf_ou_Arquivo = 'ECF' then
        iRetorno := Bematech_FI_LeituraMemoriaFiscalReducaoMFD(pchar(Inicio), pchar(Fim), pchar(stipo))
      else
        iRetorno := Bematech_FI_LeituraMemoriaFiscalSerialReducaoMFD(pchar(Inicio), pchar(Fim), pchar(stipo));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = DARUMA then
      begin
        if Analitica_ou_Sintetica = 'A' then
          Daruma_Registry_MFD_LeituraMFCompleta('1') // analitica
        else
          Daruma_Registry_MFD_LeituraMFCompleta('0'); // sintecica
        if Ecf_ou_Arquivo = 'ECF' then
          iRetorno := Daruma_FI_LeituraMemoriaFiscalReducao(pchar(Inicio), pchar(Fim))
        else
          iRetorno := Daruma_FI_LeituraMemoriaFiscalSerialReducao(pchar(Inicio), pchar(Fim));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = SWEDA then
        begin
          if stipo = 'a' then stipo := 'c';
          if Ecf_ou_Arquivo = 'ECF' then
            iRetorno := ECF_LeituraMemoriaFiscalReducaoMFD(pchar(Inicio), pchar(Fim), pchar(stipo))
          else
            iRetorno := ECF_LeituraMemoriaFiscalSerialReducaoMFD(pchar(Inicio), pchar(Fim), pchar(stipo));
          ecfMSG := cECF_Analisa_Retorno(cod_ecf);
          if ecfMSG = OK then
            Result := cECF_Retorno_Impressora(cod_ecf)
          else
            Result := ecfMSG;
        end
        else
          if COD_ECF = EPSON then
          begin
      // CGT: Desabilita a assinatura digital do Arquivo
            iRetorno := EPSON_Config_Habilita_EAD(false);
            iBuffer := 0;
            sArq := '';

            SetLength(sDados, 10000);

            if Analitica_ou_Sintetica = 'A' then
              iTipo := 0 // Completo por CRZ
            else
              iTipo := 2; // Simplificado por CRZ

            if Ecf_ou_Arquivo = 'ECF' then
              Inc(iTipo, 4) // Imprimi no ECF
            else
            begin
              Inc(iTipo, 16); // Grava em Arquivo
              sArq := SystemDrive + '\Retorno.txt';
            end;

            if sArq <> '' then
              iRetorno := EPSON_RelatorioFiscal_Leitura_MF(pchar(inicio),
                pchar(fim), iTipo, PChar(sDados), pchar(sArq), @iBuffer, 10000)
            else
              iRetorno := EPSON_RelatorioFiscal_Leitura_MF(pchar(inicio),
                pchar(fim), iTipo, PChar(sDados), '', @iBuffer, 10000);

            if iRetorno <> 0 then
              Result := cECF_Analisa_Retorno(EPSON)
            else
              Result := OK;

          end;
          
  end;
end;

// -------------------------------------------------------------------------- //
// CUPOM FISCAL

function cECF_Abre_Cupom(COD_ECF: Integer; CPF, Nome, Endereco: string;
  pbImprimirNoCabecalho: Boolean = False): string;
var
  iOpcao: Integer;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_AbreCupomMFD(pchar(copy(cpf, 1, 29)),
      pchar(copy(Nome, 1, 30)),
      pchar(copy(Endereco, 1, 80)));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin

      iRetorno := Daruma_FI_AbreCupom(pchar(copy(cpf, 1, 29)));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
      begin
        if cpf <> '' then
        begin
          
          IRetorno := Daruma_FI_IdentificaConsumidor(pchar(copy(nome, 1, 48)),
            pchar(copy(endereco, 1, 48)),
            pchar(copy(cpf, 1, 42)));
          ecfMSG := cECF_Analisa_Retorno(cod_ecf);
          if ecfMSG = OK then
            Result := cECF_Retorno_Impressora(cod_ecf)
          else
            Result := ecfMSG;
        end
        else
          Result := cECF_Retorno_Impressora(cod_ecf)
      end
      else
        Result := ecfMSG;
       //mensagem do cupom
       Daruma_Registry_AplMensagem1('Obrigado e volte sempre!');
       Daruma_Registry_AplMensagem2('Kodigo Sistema - Frente de Caixa');

    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ecf_AbreCupomMFD(pchar(copy(cpf, 1, 29)),
          pchar(copy(Nome, 1, 30)),
          pchar(copy(Endereco, 1, 80)));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          if pbImprimirNoCabecalho then
            iOpcao := 2
          else
            iOpcao := 3;

          iRetorno := EPSON_Fiscal_Abrir_Cupom(pchar(copy(cpf, 1, 20)),
            pchar(copy(Nome, 1, 30)), pchar(copy(Endereco, 1, 40)),
            pchar(copy(Endereco, 41, 39)), iOpcao);

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end;
end;


// -------------------------------------------------------------------------- //
// VENDE ITEM

function cECF_Vende_item(COD_ECF: Integer; Codigo, produto, unidade, aliquota: string; quantidade, valor_unitario, valor_desconto: real; valor_acrescimo: real; tipo_desconto_acrescimo: string; total: real): string;
var
  Sqtde, Svalor, Sdesconto, stipo_qtde, sacrescimo: string;

begin
  try
    Result := ERRO;

    if unidade = '' then
      unidade := 'UN';

    codigo := trimleft(TrimRight(copy(codigo, 1, 13)));
    produto := trimleft(TrimRight(copy(PRODUTO, 1, 29)));
    Sqtde := formatfloat('########0.000', quantidade);
    Svalor := formatfloat('########0.000', valor_unitario);
    Sacrescimo := formatfloat('########0.00', valor_acrescimo);
    Sdesconto := formatfloat('########0.00', valor_desconto);
    sTipo_qtde := 'F';


    if COD_ECF = BEMATECH then
    begin
      iRetorno := Bematech_FI_VendeItemDepartamento(pchar(codigo),
        pchar(produto),
        pchar(aliquota),
        pchar(svalor),
        pchar(sqtde),
        pchar(sacrescimo),
        pchar(sdesconto),
        '01',
        pchar(unidade));

      ecfMSG := cECF_Analisa_Retorno(cod_ecf);

      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;

    end
    else
      if COD_ECF = DARUMA then
      begin
        iRetorno := Daruma_FI_VendeItemDepartamento(pchar(codigo),
          pchar(produto),
          pchar(aliquota),
          pchar(svalor),
          pchar(sqtde),
          pchar(sacrescimo),
          pchar(sdesconto),
          '01',
          pchar(unidade));

        ecfMSG := cECF_Analisa_Retorno(cod_ecf);

        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;

      end
      else
        if COD_ECF = SWEDA then
        begin
          iRetorno := ECF_VendeItemDepartamento(pchar(codigo),
            pchar(produto),
            pchar(aliquota),
            pchar(svalor),
            pchar(sqtde),
            pchar(sacrescimo),
            pchar(sdesconto),
            '01',
            pchar(unidade));
          ecfMSG := cECF_Analisa_Retorno(cod_ecf);

          if ecfMSG = OK then
            Result := cECF_Retorno_Impressora(cod_ecf)
          else
            Result := ecfMSG;
        end
        else
          if COD_ECF = EPSON then
          begin
            iRetorno := EPSON_Fiscal_Vender_Item(pchar(codigo), pchar(produto),
              pchar(FormatarValor(Quantidade, 3)), 3, pchar(unidade),
              pchar(FormatarValor(Valor_Unitario, 2)), 2, pchar(Aliquota), 1);

            if iRetorno <> 0 then
              Result := cECF_Analisa_Retorno(EPSON)
            else
              Result := OK;

            if Result = OK then
            begin
        // GUIO: Caso tenha desconto ou acr�scimo
              if sDesconto <> '0,00' then
                iRetorno := EPSON_Fiscal_Desconto_Acrescimo_Item(
                  pchar(FormatarValor(Valor_Desconto, 2)), 2, True, False)
              else
                if sAcrescimo <> '0,00' then
                  iRetorno := EPSON_Fiscal_Desconto_Acrescimo_Item(
                    pchar(FormatarValor(Valor_Acrescimo, 2)), 2, False, False);

              if iRetorno <> 0 then
                Result := cECF_Analisa_Retorno(EPSON)
              else
                Result := OK;

            end;
          end;
  except
    Result := ERRO;
  end;
end;

// -------------------------------------------------------------------------- //
// incio do fechamento do cupom

function cECF_Inicia_Fechamento(COD_ECF: Integer; Acrescimo_ou_Desconto: string; tipo: string; valor: real): string;
var
  svalor: string;
  bDesconto: Boolean;
  bPercentual: Boolean;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    svalor := formatfloat('#########0.00', valor);
    iRetorno := Bematech_FI_IniciaFechamentoCupom(pchar(Acrescimo_ou_Desconto),
      pchar(Tipo),
      pchar(svalor));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      svalor := formatfloat('#########0.00', valor);
      iRetorno := Daruma_FI_IniciaFechamentoCupom(pchar(Acrescimo_ou_Desconto),
        pchar(Tipo),
        pchar(svalor));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        svalor := formatfloat('#########0.00', valor);
        iRetorno := ECF_IniciaFechamentoCupom(pchar(Acrescimo_ou_Desconto),
          pchar(Tipo),
          pchar(svalor));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          if Valor <> 0.00 then
          begin
            bDesconto := (UpperCase(Acrescimo_ou_Desconto) = 'D');
            bPercentual := (Tipo = '%');

            iRetorno := EPSON_Fiscal_Desconto_Acrescimo_Subtotal(
              pchar(FormatarValor(Valor, 2)), 2,
              bDesconto, bPercentual);

            if iRetorno <> 0 then
              Result := cECF_Analisa_Retorno(EPSON)
            else
              Result := OK;

          end
          else
            Result := OK;

        end;
end;

// -------------------------------------------------------------------------- //
// lancamento do pagamento

function cECF_Forma_Pgto(COD_ECF: Integer; forma_pgto: string; valor: real): string;
var
  svalor: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    svalor := formatfloat('#########0.00', valor);
    iRetorno := Bematech_FI_EfetuaFormaPagamento(pchar(forma_pgto), pchar(svalor));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      svalor := formatfloat('#########0.00', valor);
      iRetorno := Daruma_FI_EfetuaFormaPagamento(pchar(forma_pgto), pchar(svalor));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        svalor := formatfloat('#########0.00', valor);
        iRetorno := ECF_EfetuaFormaPagamento(pchar(forma_pgto), pchar(svalor));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          iRetorno := EPSON_Fiscal_Pagamento(pchar(forma_pgto),
            pchar(FormatarValor(Valor, 2)), 2, '', '');

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end;
end;

// -------------------------------------------------------------------------- //
// termina o fechamento do cupom

function cECF_Termina_Fechamento(COD_ECF: Integer; mensagem: string): string;
begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_TerminaFechamentoCupom(pchar(Mensagem));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_TerminaFechamentoCupom(pchar(Mensagem));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_TerminaFechamentoCupom(pchar(Mensagem));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          iRetorno := EPSON_Fiscal_Imprimir_MensagemEX(pchar(Mensagem));
          iRetorno := EPSON_Fiscal_Fechar_Cupom(True, False);

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end;
end;

// -------------------------------------------------------------------------- //
// fechamento do cupom resumido

function cECF_Fecha_Cupom_Resumido(cod_ecf: integer; forma_pgto: string; mensagem: string; Valor: Currency = 0.00): string;
begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    IRetorno := Bematech_FI_FechaCupomResumido(pchar(forma_pgto), pchar(mensagem));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_FechaCupomResumido(pchar(forma_pgto), pchar(mensagem));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        IRetorno := ECF_FechaCupomResumido(pchar(forma_pgto), pchar(mensagem));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          iRetorno := EPSON_Fiscal_Imprimir_MensagemEX(pchar(Mensagem));
          iRetorno := EPSON_Fiscal_Fechar_CupomEx(pchar(FormatFloat('############0.00', Valor)));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end;
end;

// -------------------------------------------------------------------------- //
// cancelar cupom

function cECF_Cancela_Cupom(COD_ECF: Integer): string;
begin
  Result := ERRO;
  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_CancelaCupom();
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_CancelaCupom();
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_CancelaCupom();
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          iRetorno := EPSON_Fiscal_Cancelar_Cupom();

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end;
end;

// -------------------------------------------------------------------------- //
// cancelar item

function cECF_Cancela_Item(COD_ECF: Integer; Item: string): string;
begin
  Result := ERRO;

  item := inttostr(strtoint(item));

  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_CancelaItemGenerico(pchar(Item));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_CancelaItemGenerico(pchar(Item));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_CancelaItemGenerico(pchar(Item));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          iRetorno := EPSON_Fiscal_Cancelar_Item(pchar(item));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end;
end;


// -------------------------------------------------------------------------- //
// OPERACOES NAO FISCAL
// abertura do relatorio gerencial

function cECF_Abre_Gerencial(COD_ECF: Integer; Texto: string): string;
begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_RelatorioGerencial(pchar(texto + char(10)));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_RelatorioGerencial(pchar(texto));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_RelatorioGerencial(pchar(texto));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
    // CGT: Verifica fun��o
          iRetorno := EPSON_NaoFiscal_Abrir_Relatorio_Gerencial('1');

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

          if Result = OK then
          begin
            iRetorno := EPSON_NaoFiscal_Imprimir_LinhaEX(pchar(Texto));

            if iRetorno <> 0 then
              Result := cECF_Analisa_Retorno(EPSON)
            else
              Result := OK;

          end;
        end;
end;

// -------------------------------------------------------------------------- //
// usar o relatorio gerencial

function cECF_Usa_Gerencial(COD_ECF: Integer; Texto: string): string;
begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    iRetorno := {Bematech_FI_RelatorioGerencial(pchar(texto));//} Bematech_FI_RelatorioGerencial(pchar(texto + chr(10)));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_RelatorioGerencial(pchar(texto));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_RelatorioGerencial(pchar(texto));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          iRetorno := EPSON_NaoFiscal_Imprimir_LinhaEX(pchar(Texto));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end;
end;

// -------------------------------------------------------------------------- //
// fechamento do relatorio gerencial

function cECF_Fecha_Gerencial(COD_ECF: Integer): string;
begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_FechaRelatorioGerencial();
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_FechaRelatorioGerencial();
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_FechaRelatorioGerencial();
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          iRetorno := EPSON_NaoFiscal_Fechar_Relatorio_Gerencial(True);

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end;
end;

// -------------------------------------------------------------------------- //
// abertura do CNFV - Comprovante nao fiscal vinculado

function cECF_Abre_CNFV(COD_ECF: Integer; Forma_Pgto: string; Valor: real; Numero_Cupom: string): string;
var
  svalor: string;
  sQtdeParcelas: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    if valor > 0 then
      svalor := formatfloat('#############0.00', valor)
    else
      svalor := '';
    iRetorno := Bematech_FI_AbreComprovanteNaoFiscalVinculado(pchar(forma_pgto),
      pchar(svalor),
      pchar(numero_cupom));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      if valor > 0 then
        svalor := formatfloat('#############0.00', valor)
      else
        svalor := '';
      iRetorno := Daruma_FI_AbreComprovanteNaoFiscalVinculado(pchar(forma_pgto),
        pchar(svalor),
        pchar(numero_cupom));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        if valor > 0 then
          svalor := formatfloat('#############0.00', valor)
        else
          svalor := '';
        iRetorno := ECF_AbreComprovanteNaoFiscalVinculado(pchar(forma_pgto),
          pchar(svalor),
          pchar(numero_cupom));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          sQtdeParcelas := FormatFloat('000', 1);
          sValor := FormatarValor(Valor, 2);

          iRetorno := EPSON_NaoFiscal_Abrir_CCD(pchar(forma_pgto), pchar(sValor), 2, pchar(sQtdeParcelas));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end;
end;

// -------------------------------------------------------------------------- //
// usar o CNFV - Comprovante nao fiscal vinculado

function cECF_Usa_CNFV(COD_ECF: Integer; Texto: string): string;
begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_UsaComprovanteNaoFiscalVinculado(pchar(texto + chr(10)));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_UsaComprovanteNaoFiscalVinculado(pchar(texto));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_UsaComprovanteNaoFiscalVinculado(pchar(texto));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          iRetorno := EPSON_NaoFiscal_Imprimir_Linha(pchar(Texto));

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end;
end;

// -------------------------------------------------------------------------- //
// fechar o CNFV - Comprovante nao fiscal vinculado

function cECF_Fecha_CNFV(COD_ECF: Integer): string;
begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_FechaComprovanteNaoFiscalVinculado();
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_FechaComprovanteNaoFiscalVinculado();
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_FechaComprovanteNaoFiscalVinculado();
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          if EPSON_CupomNaoFiscalAberto then
          begin
            iRetorno := EPSON_NaoFiscal_Fechar_CCD(True);

            if iRetorno <> 0 then
              Result := cECF_Analisa_Retorno(EPSON)
            else
              Result := OK;
          end
          else
            Result := ERRO;

        end;
end;

// -------------------------------------------------------------------------- //
// Sangria

function cECF_Sangria(COD_ECF: Integer; Valor: real): string;
var
  svalor: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    svalor := formatfloat('#############0.00', valor);
    iRetorno := Bematech_FI_Sangria(pchar(svalor));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      svalor := formatfloat('#############0.00', valor);
      iRetorno := Daruma_FI_Sangria(pchar(svalor));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        svalor := formatfloat('#############0.00', valor);
        iRetorno := ECF_Sangria(pchar(svalor));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          sValor := FormatarValor(Valor, 2);

          iRetorno := EPSON_NaoFiscal_Sangria(pchar(sValor), 2);

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end;
end;

// -------------------------------------------------------------------------- //
// Suprimento

function cECF_Suprimento(COD_ECF: Integer; Valor: real; Forma_Pgto: string): string;
var
  svalor: string;
begin

  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    svalor := formatfloat('#############0.00', valor);
    iRetorno := Bematech_FI_Suprimento(pchar(svalor), pchar(Forma_Pgto));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      svalor := formatfloat('#############0.00', valor);
      iRetorno := Daruma_FI_Suprimento(pchar(svalor), pchar(Forma_Pgto));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        svalor := formatfloat('#############0.00', valor);
        iRetorno := ECF_Suprimento(pchar(svalor), pchar(Forma_Pgto));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          sValor := FormatarValor(Valor, 2);

          iRetorno := EPSON_NaoFiscal_Fundo_Troco(pchar(sValor), 2);

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end;
end;

// -------------------------------------------------------------------------- //
// recebimento nao fiscal

function cECF_Recebimento(COD_ECF: Integer; Totalizador: string; Valor: real; Forma_Pgto: string): string;
var
  svalor: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    svalor := formatfloat('#############0.00', valor);
    iRetorno := Bematech_FI_RecebimentoNaoFiscal(pchar(Totalizador), pchar(svalor), pchar(Forma_Pgto));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      svalor := formatfloat('#############0.00', valor);
      iRetorno := Daruma_FI_RecebimentoNaoFiscal(pchar(Totalizador), pchar(svalor), pchar(Forma_Pgto));
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        svalor := formatfloat('#############0.00', valor);
        iRetorno := ECF_RecebimentoNaoFiscal(pchar(Totalizador), pchar(svalor), pchar(Forma_Pgto));
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          iRetorno := EPSON_NaoFiscal_Abrir_CCD(pchar(Forma_Pgto), pchar(FormatarValor(Valor, 2)), 2, '1');

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end;
end;

// -------------------------------------------------------------------------- //
// programar horario de verao

function cECF_Programa_Horario_Verao(COD_ECF: integer): string;
begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_ProgramaHorarioVerao();
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_ProgramaHorarioVerao();
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_ProgramaHorarioVerao();
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          iRetorno := EPSON_Config_Horario_Verao;

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end;
end;

// -------------------------------------------------------------------------- //
// programar aliquota

function cECF_Programa_Aliquota(COD_ECF: integer; aliquota: real; ICMS_OU_ISS: string): string;
var
  Itipo: integer;
  sAliquota: string;

begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    if ICMS_OU_ISS = 'ICMS' then itipo := 0;
    if ICMS_OU_ISS = 'ISS' then itipo := 1;

    saliquota := somenteNumero(formatfloat('#0.00', aliquota));
    iRetorno := Bematech_FI_ProgramaAliquota(pchar(saliquota), itipo);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      if ICMS_OU_ISS = 'ICMS' then itipo := 0;
      if ICMS_OU_ISS = 'ISS' then itipo := 1;

      saliquota := somenteNumero(formatfloat('#0.00', aliquota));
      iRetorno := Daruma_FI_ProgramaAliquota(pchar(saliquota), itipo);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        if ICMS_OU_ISS = 'ICMS' then itipo := 0;
        if ICMS_OU_ISS = 'ISS' then itipo := 1;

        saliquota := somenteNumero(formatfloat('#0.00', aliquota));
        iRetorno := ECF_ProgramaAliquota(pchar(saliquota), itipo);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          sAliquota := FormatarValor(Aliquota, 2);

          if ICMS_OU_ISS = 'ICMS' then
            iRetorno := EPSON_Config_Aliquota(pchar(sAliquota), False)
          else
            if ICMS_OU_ISS = 'ISS' then
              iRetorno := EPSON_Config_Aliquota(pchar(sAliquota), True)
            else
              ShowMessage('Comando n�o executado!');

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;

        end;
end;

// -------------------------------------------------------------------------- //
// abrir gaveta

function cECF_Abre_Gaveta(COD_ECF: integer): string;
begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_AcionaGaveta();
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_AcionaGaveta();
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := cECF_Retorno_Impressora(cod_ecf)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_AcionaGaveta();
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := cECF_Retorno_Impressora(cod_ecf)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          iRetorno := EPSON_Impressora_Abrir_Gaveta;

          if iRetorno <> 0 then
            Result := cECF_Analisa_Retorno(EPSON)
          else
            Result := OK;
        end;
end;

// -------------------------------------------------------------------------- //
// status da gaveta

function cECF_Status_Gaveta(COD_ECF: integer): string;
var
  iEstado: integer;
begin
  Result := ERRO;

  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_VerificaEstadoGaveta(iEstado);
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := inttostr(iEstado)
    else
      Result := ecfMSG;
  end
  else
    if COD_ECF = DARUMA then
    begin
      iRetorno := Daruma_FI_VerificaEstadoGaveta(iEstado);
      ecfMSG := cECF_Analisa_Retorno(cod_ecf);
      if ecfMSG = OK then
        Result := inttostr(iEstado)
      else
        Result := ecfMSG;
    end
    else
      if COD_ECF = SWEDA then
      begin
        iRetorno := ECF_VerificaEstadoGaveta(iEstado);
        ecfMSG := cECF_Analisa_Retorno(cod_ecf);
        if ecfMSG = OK then
          Result := inttostr(iEstado)
        else
          Result := ecfMSG;
      end
      else
        if COD_ECF = EPSON then
        begin
          if EPSON_GavetaAberta then
            Result := OK
          else
            Result := cECF_Analisa_Retorno(EPSON);

        end;
end;

// -------------------------------------------------------------------------- //
// programar totalizador nao fiscal

function cECF_Programa_Totalizador(COD_ECF: Integer; Indice: integer; descricao: string): string;
begin
  Result := ERRO;
  if COD_ECF = BEMATECH then
  begin
    iRetorno := Bematech_FI_NomeiaTotalizadorNaoSujeitoIcms(indice, pchar(descricao));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end;
  if COD_ECF = DARUMA then
  begin
    iRetorno := Daruma_FI_NomeiaTotalizadorNaoSujeitoIcms(indice, pchar(descricao));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end;
  if COD_ECF = SWEDA then
  begin
    iRetorno := ECF_NomeiaTotalizadorNaoSujeitoIcms(indice, pchar(descricao));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end;
end;

// -------------------------------------------------------------------------- //
// programar forma de pagamento

function cECF_Programa_Forma_Pgto(COD_ECF: Integer; Forma_Pgto: string; Vinculado: string): string;
var sVinc: string;
begin
  Result := ERRO;
  if COD_ECF = BEMATECH then
  begin
    if vinculado = 'SIM' then sVinc := '1' else sVinc := '0';

    iRetorno := Bematech_FI_ProgramaFormaPagamentoMFD(pchar(Forma_Pgto), pchar(sVinc));

    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end;

  if COD_ECF = DARUMA then
  begin
    iRetorno := Daruma_FI_ProgramaFormasPagamento(pchar(forma_pgto));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end;

  if COD_ECF = SWEDA then
  begin
    iRetorno := ECF_ProgramaFormasPagamento(pchar(forma_pgto));
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end;
end;

// -------------------------------------------------------------------------- //
// liberar porta serial

function cECF_Daruma_Libera_Porta(SIM_NAO: string): string;
begin
  if SIM_NAO = 'SIM' then
  begin
    // QTDE de instancias serah permitido na porta utilizada pela daruma
    iRetorno := Daruma_Registry_AlteraRegistry('ControlePorta', '0');
    // bloquear a porta pela dll
    iRetorno := Daruma_Registry_AlteraRegistry('ThreadNoStartup', '0');
  end
  else
  begin
    iRetorno := Daruma_Registry_AlteraRegistry('ControlePorta', '2');
    iRetorno := Daruma_Registry_AlteraRegistry('ThreadNoStartup', '0');
  end;
end;

// -------------------------------------------------------------------------- //
// programar z automatico

function cECF_Programa_Z_Automatico(COD_ECF: INTEGER; SIM_NAO: string): string;
begin
  Result := ERRO;
  if COD_ECF = DARUMA then
  begin
    if SIM_NAO = 'SIM' then
    begin
      iRetorno := Daruma_Registry_ZAutomatica('1');
      IRetorno := Daruma_FI_CfgRedZAutomatico('1');
    end
    else
    begin
      iRetorno := Daruma_Registry_ZAutomatica('0');
      iRetorno := Daruma_FI_CfgRedZAutomatico('0');
    end;
    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end;


  if COD_ECF = SWEDA then
  begin
    if SIM_NAO = 'SIM' then
      iRetorno := ECF_ZAUTO('1')
    else
      iRetorno := ECF_ZAUTO('0');

    ecfMSG := cECF_Analisa_Retorno(cod_ecf);
    if ecfMSG = OK then
      Result := cECF_Retorno_Impressora(cod_ecf)
    else
      Result := ecfMSG;
  end;
end;

// -------------------------------------------------------------------------- //

function cECF_Desliga_Janelas(COD_ECF: integer): string;
begin
  if COD_ECF = SWEDA then
  begin
    iRetorno := ECF_LigaDesligaJanelas('0', '0');
    Result := OK;
  end;
end;

// -------------------------------------------------------------------------- //

function EPSON_CupomNaoFiscalAberto: Boolean;
var
  sDados: string;
  ST4: string;
  iST4: Integer;

begin
  SetLength(sDados, 56);
  Result := False;

  iRetorno := EPSON_Obter_Estado_Cupom(PChar(sDados));

  if iRetorno <> 0 then
    cECF_Analisa_Retorno(EPSON);

  // CGT: Cupom N�o FIscal Aberto
  if Copy(sDados, 1, 2) = '05' then
    Result := True;

end;

// -------------------------------------------------------------------------- //

function EPSON_CupomFiscalAberto: Boolean;
var
  sDados: string;

begin
  SetLength(sDados, 56);
  Result := False;

  iRetorno := EPSON_Obter_Estado_Cupom(PChar(sDados));

  if iRetorno <> 0 then
    cECF_Analisa_Retorno(EPSON)
  else
  // CGT: Cupom FIscal Aberto
    if Copy(sDados, 1, 2) = '01' then
      Result := True;

end;

// -------------------------------------------------------------------------- //

function EPSON_ECFLigada: string;
var
  ST3: string;
  iST3: Integer;
  sDados: string;
  I: Integer;

begin
  Result := OK;

  for I := 1 to 20 do
    sDados := sDados + ' ';

  iRetorno := EPSON_Obter_Estado_Impressora(PChar(sDados));

  ST3 := Copy(sDados, 9, 4);
  iST3 := StrToInt('$' + ST3);

  if (iST3 >= 32768) then
    Result := 'Impressora Desligada!'
  else
    if iRetorno <> 0 then
      Result := cECF_Analisa_Retorno(EPSON);

end;

// -------------------------------------------------------------------------- //

function EPSON_NumeroSerie: string;
var
  sDados: string;

begin
  SetLength(sDados, 108);

  iRetorno := EPSON_Obter_Dados_Impressora(pchar(sDados));

  if iRetorno = 0 then
    Result := copy(sDados, 1, 20)
  else
    Result := cECF_Analisa_Retorno(EPSON);

end;

// -------------------------------------------------------------------------- //

function EPSON_NumeroCaixa: string;
var
  sDados: string;

begin
  SetLength(sDados, 8);

  iRetorno := EPSON_Obter_Numero_ECF_Loja(pchar(sDados));

  if iRetorno = 0 then
    Result := copy(sDados, 1, 3)
  else
    Result := cECF_Analisa_Retorno(EPSON);

end;

// -------------------------------------------------------------------------- //

function EPSON_VersaoSoftwareBasico: string;
var
  sVersao: array[0..9] of Char;
  sData: array[0..9] of Char;
  sHora: array[0..7] of Char;

begin
  iRetorno := EPSON_Obter_Versao_SWBasicoEX(sVersao, sData, sHora);

  if iRetorno = 0 then
    Result := sVersao
  else
    Result := cECF_Analisa_Retorno(EPSON);
end;

// -------------------------------------------------------------------------- //

function EPSON_DataHoraSoftwareBasico: string;
var
  sVersao: array[0..9] of Char;
  sData: array[0..9] of Char;
  sHora: array[0..7] of Char;

begin
  iRetorno := EPSON_Obter_Versao_SWBasicoEX(sVersao, sData, sHora);

  if iRetorno = 0 then
    Result := sData + sHora
  else
    Result := cECF_Analisa_Retorno(EPSON);
end;

// -------------------------------------------------------------------------- //

function EPSON_GavetaAberta: Boolean;
var
  ST3: string;
  iST3: Integer;
  sDados: string;
  I: Integer;
  sMensagem: string;

begin
  Result := False;

  for I := 1 to 20 do
    sDados := sDados + ' ';

  iRetorno := EPSON_Obter_Estado_Impressora(PChar(sDados));

  if (iRetorno = 0) then
  begin
    ST3 := Copy(sDados, 9, 4);
    iST3 := StrToInt('$' + ST3);

    if (iST3 >= 32768) then
      iST3 := iST3 - 32768;

    if (iST3 >= 16384) then
      iST3 := iST3 - 16384;

    if (iST3 >= 8192) then
      iST3 := iST3 - 8192;

    if (iST3 >= 4096) then
      Result := True;

  end;
end;

// -------------------------------------------------------------------------- //

function cECF_VerificarRelatoriosGerenciais(COD_ECF: Integer): string;
var
  sRet: string;
  I: Integer;

begin
  case COD_ECF of
    BEMATECH: Result := ''; // Implementar

    DARUMA:
      begin
//          Result := DARUMA_FIMFD_VerificaRelatoriosGerenciais()
      end;

    SWEDA: Result := ''; // Implementar
    EPSON:
      begin
        SetLength(sRet, 421);
        iRetorno := EPSON_Obter_Tabela_Relatorios_Gerenciais(pchar(sRet));

        if iRetorno = 0 then
        begin
          Result := OK;
          I := 1;

          while sRet <> '' do
          begin
             // GUIO: Indice do Relat�rio
            aRelatoriosGerenciais[I][1] := copy(sRet, 1, 2);
            aRelatoriosGerenciais[I][2] := copy(sRet, 3, 15);
            Inc(I);

            Delete(sRet, 1, 21);

            if trim(copy(sRet, 3, 15)) = '' then
              Break;
          end;
        end
        else
          Result := cECF_Analisa_Retorno(EPSON);

      end;
  end;
end;

end.
