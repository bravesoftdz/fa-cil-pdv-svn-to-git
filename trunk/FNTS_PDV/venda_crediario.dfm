object frmVenda_Crediario: TfrmVenda_Crediario
  Left = 880
  Top = 183
  BorderStyle = bsNone
  Caption = 'frmVenda_Crediario'
  ClientHeight = 395
  ClientWidth = 303
  Color = clBlack
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = pop_consumid
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pn_consumidor: TFlatPanel
    Left = 0
    Top = 0
    Width = 305
    Height = 395
    ParentColor = True
    ColorHighLight = clBlack
    ColorShadow = clBlack
    TabOrder = 0
    UseDockManager = True
    object RzLabel10: TRzLabel
      Left = 6
      Top = 6
      Width = 287
      Height = 27
      Alignment = taCenter
      AutoSize = False
      Caption = 'CREDI'#193'RIO'
      Font.Charset = ANSI_CHARSET
      Font.Color = clYellow
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
      ShadowColor = clBlack
      TextStyle = tsShadow
    end
    object RzLabel9: TRzLabel
      Left = 9
      Top = 39
      Width = 48
      Height = 17
      AutoSize = False
      Caption = 'Cliente:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      ShadowColor = clBlack
      TextStyle = tsShadow
    end
    object sh_cred_cliente: TShape
      Left = 62
      Top = 34
      Width = 235
      Height = 24
      Brush.Color = clBlack
      Pen.Color = clSilver
      Shape = stRoundRect
    end
    object sh_consumid_endereco: TShape
      Left = 5
      Top = 63
      Width = 293
      Height = 30
      Brush.Color = clBlack
      Pen.Color = clSilver
      Shape = stRoundRect
    end
    object RzLabel12: TRzLabel
      Left = 9
      Top = 263
      Width = 160
      Height = 17
      AutoSize = False
      Caption = 'Quantidade de Presta'#231#245'es:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      ShadowColor = clBlack
      TextStyle = tsShadow
    end
    object sh_cred_prestacao: TShape
      Left = 172
      Top = 258
      Width = 51
      Height = 25
      Brush.Color = clBlack
      Pen.Color = clSilver
      Shape = stRoundRect
    end
    object Shape1: TShape
      Left = 5
      Top = 223
      Width = 293
      Height = 30
      Brush.Color = clBlack
      Pen.Color = clSilver
      Shape = stRoundRect
    end
    object Shape2: TShape
      Left = 5
      Top = 79
      Width = 293
      Height = 153
      Brush.Color = clBlack
      Pen.Color = clSilver
    end
    object FlatPanel3: TFlatPanel
      Left = 8
      Top = 352
      Width = 281
      Height = 41
      ParentColor = True
      ColorHighLight = clBlack
      ColorShadow = clBlack
      TabOrder = 1
      UseDockManager = True
      object bt_gravar_crediario: TAdvGlowButton
        Left = 42
        Top = 11
        Width = 100
        Height = 25
        Caption = 'Confirmar'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        FocusType = ftHot
        NotesFont.Charset = DEFAULT_CHARSET
        NotesFont.Color = clWindowText
        NotesFont.Height = -11
        NotesFont.Name = 'Tahoma'
        NotesFont.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = bt_gravar_crediarioClick
        OnEnter = bt_gravar_crediarioEnter
        Appearance.ColorChecked = 16111818
        Appearance.ColorCheckedTo = 16367008
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 16111818
        Appearance.ColorDownTo = 16367008
        Appearance.ColorHot = 16117985
        Appearance.ColorHotTo = 16372402
        Appearance.ColorMirrorHot = 16107693
        Appearance.ColorMirrorHotTo = 16775412
        Appearance.ColorMirrorDown = 16102556
        Appearance.ColorMirrorDownTo = 16768988
        Appearance.ColorMirrorChecked = 16102556
        Appearance.ColorMirrorCheckedTo = 16768988
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
      end
      object bt_cancelar_crediario: TAdvGlowButton
        Left = 154
        Top = 11
        Width = 100
        Height = 25
        Caption = 'ESC Cancelar'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        FocusType = ftHot
        NotesFont.Charset = DEFAULT_CHARSET
        NotesFont.Color = clWindowText
        NotesFont.Height = -11
        NotesFont.Name = 'Tahoma'
        NotesFont.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = bt_cancelar_crediarioClick
        OnEnter = bt_cancelar_crediarioEnter
        Appearance.ColorChecked = 16111818
        Appearance.ColorCheckedTo = 16367008
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 16111818
        Appearance.ColorDownTo = 16367008
        Appearance.ColorHot = 16117985
        Appearance.ColorHotTo = 16372402
        Appearance.ColorMirrorHot = 16107693
        Appearance.ColorMirrorHotTo = 16775412
        Appearance.ColorMirrorDown = 16102556
        Appearance.ColorMirrorDownTo = 16768988
        Appearance.ColorMirrorChecked = 16102556
        Appearance.ColorMirrorCheckedTo = 16768988
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
      end
    end
    object ed_cred_cliente: TRzEdit
      Left = 64
      Top = 35
      Width = 225
      Height = 21
      Color = clBlack
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      FocusColor = 14511872
      FrameStyle = fsNone
      FrameVisible = True
      FramingPreference = fpCustomFraming
      ParentFont = False
      TabOrder = 0
      OnEnter = ed_cred_clienteEnter
      OnExit = ed_cred_clienteExit
      OnKeyPress = ed_cred_clienteKeyPress
    end
    object FlatPanel1: TFlatPanel
      Left = 6
      Top = 67
      Width = 291
      Height = 178
      ParentColor = True
      Enabled = False
      ColorHighLight = clBlack
      ColorShadow = clBlack
      TabOrder = 2
      UseDockManager = True
      object lb_cred_nome: TRzLabel
        Left = 80
        Top = 3
        Width = 209
        Height = 17
        AutoSize = False
        Caption = 'iCloud Inform'#225'tica'
        Font.Charset = ANSI_CHARSET
        Font.Color = clYellow
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object lb_cred_endereco: TRzLabel
        Left = 25
        Top = 24
        Width = 263
        Height = 17
        AutoSize = False
        Caption = 'Rua Conde de Linhares, 462'
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object lb_cred_bairro: TRzLabel
        Left = 25
        Top = 40
        Width = 263
        Height = 17
        AutoSize = False
        Caption = 'Filomena '
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object lb_cred_cidade: TRzLabel
        Left = 25
        Top = 56
        Width = 128
        Height = 17
        AutoSize = False
        Caption = 'Nova Ven'#233'cia'
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object lb_cred_cpf: TRzLabel
        Left = 25
        Top = 72
        Width = 263
        Height = 17
        AutoSize = False
        Caption = 'CPF/CNPJ: 000.000.000-00'
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object RzLabel6: TRzLabel
        Left = 9
        Top = 95
        Width = 112
        Height = 17
        AutoSize = False
        Caption = 'Situa'#231#227'o do Cadastro:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object lb_cred_situacao: TRzLabel
        Left = 121
        Top = 94
        Width = 112
        Height = 17
        AutoSize = False
        Caption = '3'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object RzLabel8: TRzLabel
        Left = 9
        Top = 115
        Width = 96
        Height = 17
        AutoSize = False
        Caption = 'Limite de Cr'#233'dito:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object lb_cred_limite: TRzLabel
        Left = 97
        Top = 115
        Width = 96
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'R$ 1.000,00'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object RzLabel13: TRzLabel
        Left = 9
        Top = 131
        Width = 96
        Height = 17
        AutoSize = False
        Caption = 'Utilizado:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object lb_cred_utilizado: TRzLabel
        Left = 97
        Top = 131
        Width = 96
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'R$ 1.000,00'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object RzLabel15: TRzLabel
        Left = 9
        Top = 147
        Width = 96
        Height = 17
        AutoSize = False
        Caption = 'Dispon'#237'vel:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object lb_cred_disponivel: TRzLabel
        Left = 97
        Top = 147
        Width = 96
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'R$ 1.000,00'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object lb_cred_uf: TRzLabel
        Left = 161
        Top = 56
        Width = 18
        Height = 17
        AutoSize = False
        Caption = 'ES'
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object lb_cred_cep: TRzLabel
        Left = 185
        Top = 56
        Width = 65
        Height = 17
        AutoSize = False
        Caption = '29830-000'
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object lb_cred_codigo: TRzLabel
        Left = 8
        Top = 3
        Width = 65
        Height = 17
        AutoSize = False
        Caption = '00000001'
        Font.Charset = ANSI_CHARSET
        Font.Color = clYellow
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object lb_cred_atualizado: TRzLabel
        Left = 9
        Top = 165
        Width = 272
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Atualizado em 01/01/2009 as 18:00'
        Font.Charset = ANSI_CHARSET
        Font.Color = 5855577
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object pn_tampa: TFlatPanel
        Left = 257
        Top = 153
        Width = 289
        Height = 176
        ParentColor = True
        Visible = False
        ColorHighLight = clBlack
        ColorShadow = clBlack
        TabOrder = 0
        UseDockManager = True
      end
    end
    object ed_cred_prestacao: TRzSpinEdit
      Left = 174
      Top = 259
      Width = 47
      Height = 21
      AllowKeyEdit = True
      FlatButtonColor = clBlack
      Max = 100.000000000000000000
      Min = 1.000000000000000000
      Value = 1.000000000000000000
      Color = clBlack
      FlatButtons = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      FocusColor = 14511872
      FrameHotColor = clBlack
      FrameHotStyle = fsNone
      FrameStyle = fsNone
      FrameVisible = True
      FramingPreference = fpCustomFraming
      ParentFont = False
      TabOrder = 3
      OnEnter = ed_cred_prestacaoEnter
      OnExit = ed_cred_prestacaoExit
      OnKeyPress = ed_cred_prestacaoKeyPress
    end
    object pn_veiculo: TFlatPanel
      Left = 0
      Top = 287
      Width = 305
      Height = 70
      ParentColor = True
      ColorHighLight = clBlack
      ColorShadow = clBlack
      TabOrder = 4
      UseDockManager = True
      object RzLabel21: TRzLabel
        Left = 9
        Top = 22
        Width = 73
        Height = 17
        AutoSize = False
        Caption = 'KM'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object sh_consumid_km: TShape
        Left = 6
        Top = 37
        Width = 93
        Height = 24
        Brush.Color = clBlack
        Pen.Color = clSilver
        Shape = stRoundRect
      end
      object RzLabel22: TRzLabel
        Left = 109
        Top = 22
        Width = 73
        Height = 17
        AutoSize = False
        Caption = 'Placa'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object sh_consumid_placa: TShape
        Left = 106
        Top = 37
        Width = 89
        Height = 24
        Brush.Color = clBlack
        Pen.Color = clSilver
        Shape = stRoundRect
      end
      object RzLabel16: TRzLabel
        Left = 205
        Top = 22
        Width = 78
        Height = 17
        AutoSize = False
        Caption = 'Vendedor'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object sh_consumid_vendedor: TShape
        Left = 202
        Top = 37
        Width = 94
        Height = 24
        Brush.Color = clBlack
        Pen.Color = clSilver
        Shape = stRoundRect
      end
      object RzLabel17: TRzLabel
        Left = 6
        Top = 6
        Width = 287
        Height = 22
        Alignment = taCenter
        AutoSize = False
        Caption = 'VE'#205'CULO'
        Font.Charset = ANSI_CHARSET
        Font.Color = clYellow
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        ShadowColor = clBlack
        TextStyle = tsShadow
      end
      object ed_consumid_km: TRzEdit
        Left = 8
        Top = 38
        Width = 89
        Height = 21
        Color = clBlack
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        FocusColor = 14511872
        FrameStyle = fsNone
        FrameVisible = True
        FramingPreference = fpCustomFraming
        ParentFont = False
        TabOnEnter = True
        TabOrder = 0
      end
      object ed_consumid_placa: TRzEdit
        Left = 108
        Top = 38
        Width = 85
        Height = 21
        Color = clBlack
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        FocusColor = 14511872
        FrameStyle = fsNone
        FrameVisible = True
        FramingPreference = fpCustomFraming
        ParentFont = False
        TabOnEnter = True
        TabOrder = 1
      end
      object ed_consumid_vendedor: TRzEdit
        Left = 204
        Top = 38
        Width = 90
        Height = 21
        Color = clBlack
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        FocusColor = 14511872
        FrameStyle = fsNone
        FrameVisible = True
        FramingPreference = fpCustomFraming
        ParentFont = False
        TabOrder = 2
        OnKeyPress = ed_consumid_vendedorKeyPress
      end
    end
  end
  object pop_consumid: TAdvPopupMenu
    MenuStyler = frmModulo.estilo_menu
    Version = '2.5.4.0'
    Left = 280
    Top = 368
    object MenuItem2: TMenuItem
      Caption = 'Cancelar'
      ShortCut = 27
      OnClick = MenuItem2Click
    end
  end
end
