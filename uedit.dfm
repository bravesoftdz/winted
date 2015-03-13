object wEdit: TwEdit
  Left = 552
  Top = 189
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Edit Entry'
  ClientHeight = 430
  ClientWidth = 516
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnBottom: TPanel
    Left = 0
    Top = 396
    Width = 516
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    DesignSize = (
      516
      34)
    object btOkay: TButton
      Left = 432
      Top = 4
      Width = 79
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btOkayClick
    end
    object btCancel: TButton
      Left = 349
      Top = 4
      Width = 79
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 1
      OnClick = btCancelClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 516
    Height = 396
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 1
    object pcPages: TPageControl
      Left = 5
      Top = 5
      Width = 506
      Height = 386
      ActivePage = tsGeneral
      Align = alClient
      TabOrder = 0
      TabWidth = 120
      object tsGeneral: TTabSheet
        Caption = '&General'
        DesignSize = (
          498
          358)
        object lblName: TLabel
          Left = 4
          Top = 40
          Width = 33
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '&Name'
          FocusControl = edName
        end
        object lblURL: TLabel
          Left = 8
          Top = 64
          Width = 29
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '&URLs'
        end
        object lblEpisode: TLabel
          Left = 256
          Top = 256
          Width = 38
          Height = 13
          Caption = '&Episode'
        end
        object Bevel1: TBevel
          Left = 12
          Top = 240
          Width = 469
          Height = 2
        end
        object lblSeasonTip: TLabel
          Left = 80
          Top = 276
          Width = 394
          Height = 26
          Caption = 
            'If you set Season to 0 only  the Episode will be taken into acco' +
            'unt. If you set Season and Episode to 0, WinTED will automatical' +
            'ly determine the newest episode.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object sbPreDef: TSpeedButton
          Left = 42
          Top = 4
          Width = 141
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Load from &Presets'
          PopupMenu = pmPredef
          OnClick = sbPreDefClick
        end
        object Label3: TLabel
          Left = 80
          Top = 324
          Width = 393
          Height = 26
          AutoSize = False
          Caption = 
            'Only new items will be downloaded. So don'#39't be puzzled if nothin' +
            'g is downloaded after you freshly created this entry.'
          WordWrap = True
        end
        object Image1: TImage
          Left = 60
          Top = 276
          Width = 16
          Height = 16
          AutoSize = True
          Picture.Data = {
            07544269746D617036030000424D360300000000000036000000280000001000
            0000100000000100180000000000000300000000000000000000000000000000
            00000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF848284
            8482840000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF0000FF0000FF0000FF0000000000008482840000FF0000FF0000FF0000FF00
            00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF000000FFFFFF000000
            8482840000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF000000000000C6C3C6FFFFFF0000008482848482840000FF0000FF0000FF00
            00FF0000FF0000FF0000FF000000000000C6C3C6FFFFFFFFFFFFFFFFFFC6C3C6
            0000000000008482848482840000FF0000FF0000FF0000FF000000C6C3C6FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000084828484828400
            00FF0000FF848284FFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FF0000
            FFFFFFFFFFFFC6C3C60000008482840000FF848284C6C3C6FFFFFFFFFFFFFFFF
            FFFFFFFF848284FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000084
            8284848284FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF000000848284848284FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF848284FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000084
            8284848284FFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF000000848284848284FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000000
            00FF0000FF848284FFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFF0000008482840000FF0000FF848284FFFFFFFFFFFFFFFF
            FFFFFFFFFF0000FF0000FF0000FFFFFFFFFFFFFFFFFFC6C3C60000000000FF00
            00FF0000FF0000FF848284848284FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF0000000000000000FF0000FF0000FF0000FF0000FF0000FF0000FF8482
            848482848482848482848482848482848482840000FF0000FF0000FF0000FF00
            00FF}
          Transparent = True
        end
        object Image2: TImage
          Left = 60
          Top = 324
          Width = 16
          Height = 16
          AutoSize = True
          Picture.Data = {
            07544269746D617036030000424D360300000000000036000000280000001000
            0000100000000100180000000000000300000000000000000000000000000000
            00000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF848284
            8482840000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF0000FF0000FF0000FF0000000000008482840000FF0000FF0000FF0000FF00
            00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF000000FFFFFF000000
            8482840000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF000000000000C6C3C6FFFFFF0000008482848482840000FF0000FF0000FF00
            00FF0000FF0000FF0000FF000000000000C6C3C6FFFFFFFFFFFFFFFFFFC6C3C6
            0000000000008482848482840000FF0000FF0000FF0000FF000000C6C3C6FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000084828484828400
            00FF0000FF848284FFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FF0000
            FFFFFFFFFFFFC6C3C60000008482840000FF848284C6C3C6FFFFFFFFFFFFFFFF
            FFFFFFFF848284FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000084
            8284848284FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF000000848284848284FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF848284FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000084
            8284848284FFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF000000848284848284FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000000
            00FF0000FF848284FFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFF0000008482840000FF0000FF848284FFFFFFFFFFFFFFFF
            FFFFFFFFFF0000FF0000FF0000FFFFFFFFFFFFFFFFFFC6C3C60000000000FF00
            00FF0000FF0000FF848284848284FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF0000000000000000FF0000FF0000FF0000FF0000FF0000FF0000FF8482
            848482848482848482848482848482848482840000FF0000FF0000FF0000FF00
            00FF}
          Transparent = True
        end
        object Label9: TLabel
          Left = 60
          Top = 208
          Width = 393
          Height = 29
          AutoSize = False
          Caption = 
            'You can use XML-Feeds or a normal Webpage. If you use a normal  ' +
            'webpage, all links are extracted and filtered according to your ' +
            'rules on the next page.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object Image5: TImage
          Left = 40
          Top = 208
          Width = 16
          Height = 16
          AutoSize = True
          Picture.Data = {
            07544269746D617036030000424D360300000000000036000000280000001000
            0000100000000100180000000000000300000000000000000000000000000000
            00000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF848284
            8482840000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF0000FF0000FF0000FF0000000000008482840000FF0000FF0000FF0000FF00
            00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF000000FFFFFF000000
            8482840000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF000000000000C6C3C6FFFFFF0000008482848482840000FF0000FF0000FF00
            00FF0000FF0000FF0000FF000000000000C6C3C6FFFFFFFFFFFFFFFFFFC6C3C6
            0000000000008482848482840000FF0000FF0000FF0000FF000000C6C3C6FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000084828484828400
            00FF0000FF848284FFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FF0000
            FFFFFFFFFFFFC6C3C60000008482840000FF848284C6C3C6FFFFFFFFFFFFFFFF
            FFFFFFFF848284FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000084
            8284848284FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF000000848284848284FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF848284FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000084
            8284848284FFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF000000848284848284FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000000
            00FF0000FF848284FFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFF0000008482840000FF0000FF848284FFFFFFFFFFFFFFFF
            FFFFFFFFFF0000FF0000FF0000FFFFFFFFFFFFFFFFFFC6C3C60000000000FF00
            00FF0000FF0000FF848284848284FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF0000000000000000FF0000FF0000FF0000FF0000FF0000FF0000FF8482
            848482848482848482848482848482848482840000FF0000FF0000FF0000FF00
            00FF}
          Transparent = True
        end
        object sbDelURL: TSpeedButton
          Left = 10
          Top = 181
          Width = 29
          Height = 20
          Glyph.Data = {
            DE000000424DDE0000000000000076000000280000000D0000000D0000000100
            0400000000006800000000000000000000001000000010000000000000000000
            BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7000777777777777700077777777777770007777777777777000777777777777
            70007700000000077000770CCCCCCC0770007700000000077000777777777777
            7000777777777777700077777777777770007777777777777000777777777777
            7000}
          OnClick = sbDelURLClick
        end
        object sbAddURL: TSpeedButton
          Left = 10
          Top = 157
          Width = 29
          Height = 20
          Glyph.Data = {
            DE000000424DDE0000000000000076000000280000000D0000000D0000000100
            0400000000006800000000000000000000001000000010000000000000000000
            BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            700077777777777770007777700077777000777770C077777000777770C07777
            7000770000C000077000770CCCCCCC077000770000C000077000777770C07777
            7000777770C07777700077777000777770007777777777777000777777777777
            7000}
          OnClick = sbAddURLClick
        end
        object edName: TEdit
          Left = 40
          Top = 36
          Width = 451
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          MaxLength = 255
          TabOrder = 0
          Text = 'NewItem'
          OnExit = edNameExit
        end
        object edSeason: TEdit
          Left = 200
          Top = 252
          Width = 49
          Height = 21
          MaxLength = 2
          TabOrder = 1
          Text = '0'
          OnKeyPress = edSeasonKeyPress
        end
        object edEpisode: TEdit
          Left = 300
          Top = 252
          Width = 49
          Height = 21
          MaxLength = 4
          TabOrder = 2
          Text = '0'
          OnKeyPress = edSeasonKeyPress
        end
        object cbSeason: TRadioButton
          Left = 40
          Top = 254
          Width = 157
          Height = 17
          Caption = 'Start downloading at &Season'
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          TabStop = True
        end
        object cbAnything: TRadioButton
          Left = 40
          Top = 304
          Width = 181
          Height = 17
          Caption = 'Download anything found'
          TabOrder = 4
        end
        object Panel2: TPanel
          Left = 40
          Top = 60
          Width = 452
          Height = 141
          BevelOuter = bvNone
          BorderStyle = bsSingle
          Caption = ' '
          TabOrder = 5
          object hcURLs: THeaderControl
            Left = 0
            Top = 0
            Width = 448
            Height = 17
            Sections = <
              item
                ImageIndex = -1
                MinWidth = 100
                Text = 'URL'
                Width = 350
              end
              item
                ImageIndex = -1
                MaxWidth = 100
                MinWidth = 100
                Text = 'Visited'
                Width = 100
              end>
            OnSectionResize = hcURLsSectionResize
          end
          object lbURLs: TListBox
            Left = 0
            Top = 17
            Width = 448
            Height = 120
            Style = lbOwnerDrawFixed
            Align = alClient
            BorderStyle = bsNone
            ItemHeight = 16
            TabOrder = 1
            OnDblClick = lbURLsDblClick
            OnDrawItem = lbURLsDrawItem
          end
        end
      end
      object tsDoDont: TTabSheet
        Caption = 'Keyword Filter'
        ImageIndex = 1
        object gbTitle: TGroupBox
          Left = 4
          Top = 8
          Width = 489
          Height = 165
          Caption = 'Item Title (if XML) / Link Title (if HTML)'
          TabOrder = 0
          object btDelDo: TSpeedButton
            Left = 216
            Top = 135
            Width = 29
            Height = 21
            Hint = 'Delete selected entry'
            Glyph.Data = {
              DE000000424DDE0000000000000076000000280000000D0000000D0000000100
              0400000000006800000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              7000777777777777700077777777777770007777777777777000777777777777
              70007700000000077000770CCCCCCC0770007700000000077000777777777777
              7000777777777777700077777777777770007777777777777000777777777777
              7000}
            OnClick = btDelDoClick
          end
          object btAddDo: TSpeedButton
            Left = 184
            Top = 135
            Width = 29
            Height = 21
            Hint = 'Add new entry'
            Glyph.Data = {
              DE000000424DDE0000000000000076000000280000000D0000000D0000000100
              0400000000006800000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              700077777777777770007777700077777000777770C077777000777770C07777
              7000770000C000077000770CCCCCCC077000770000C000077000777770C07777
              7000777770C07777700077777000777770007777777777777000777777777777
              7000}
            OnClick = btAddDoClick
          end
          object Label1: TLabel
            Left = 8
            Top = 20
            Width = 73
            Height = 13
            AutoSize = False
            Caption = 'Must Contain'
            Color = clBtnFace
            ParentColor = False
          end
          object btDelDont: TSpeedButton
            Left = 453
            Top = 135
            Width = 29
            Height = 21
            Hint = 'Delete selected entry'
            Glyph.Data = {
              DE000000424DDE0000000000000076000000280000000D0000000D0000000100
              0400000000006800000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              7000777777777777700077777777777770007777777777777000777777777777
              70007700000000077000770CCCCCCC0770007700000000077000777777777777
              7000777777777777700077777777777770007777777777777000777777777777
              7000}
            OnClick = btDelDontClick
          end
          object btAddDont: TSpeedButton
            Left = 421
            Top = 135
            Width = 29
            Height = 21
            Hint = 'Add new entry'
            Glyph.Data = {
              DE000000424DDE0000000000000076000000280000000D0000000D0000000100
              0400000000006800000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              700077777777777770007777700077777000777770C077777000777770C07777
              7000770000C000077000770CCCCCCC077000770000C000077000777770C07777
              7000777770C07777700077777000777770007777777777777000777777777777
              7000}
            OnClick = btAddDontClick
          end
          object Label2: TLabel
            Left = 252
            Top = 20
            Width = 101
            Height = 13
            AutoSize = False
            Caption = 'Must Never Contain'
            Color = clBtnFace
            ParentColor = False
          end
          object lbDo: TListBox
            Left = 8
            Top = 36
            Width = 237
            Height = 97
            ItemHeight = 13
            TabOrder = 0
            OnDblClick = lbDoDblClick
          end
          object cbAllDo: TCheckBox
            Left = 8
            Top = 140
            Width = 141
            Height = 17
            Caption = '&Must match all patterns'
            TabOrder = 1
          end
          object lbDont: TListBox
            Left = 252
            Top = 36
            Width = 229
            Height = 97
            ItemHeight = 13
            TabOrder = 2
            OnDblClick = lbDoDblClick
          end
        end
        object GroupBox2: TGroupBox
          Left = 4
          Top = 184
          Width = 489
          Height = 165
          Caption = 'Any Filename referenced to inside of .torrent file'
          TabOrder = 1
          object btDelFDo: TSpeedButton
            Left = 216
            Top = 135
            Width = 29
            Height = 21
            Hint = 'Delete selected entry'
            Glyph.Data = {
              DE000000424DDE0000000000000076000000280000000D0000000D0000000100
              0400000000006800000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              7000777777777777700077777777777770007777777777777000777777777777
              70007700000000077000770CCCCCCC0770007700000000077000777777777777
              7000777777777777700077777777777770007777777777777000777777777777
              7000}
            OnClick = btDelFDoClick
          end
          object btAddFDo: TSpeedButton
            Left = 184
            Top = 135
            Width = 29
            Height = 21
            Hint = 'Add new entry'
            Glyph.Data = {
              DE000000424DDE0000000000000076000000280000000D0000000D0000000100
              0400000000006800000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              700077777777777770007777700077777000777770C077777000777770C07777
              7000770000C000077000770CCCCCCC077000770000C000077000777770C07777
              7000777770C07777700077777000777770007777777777777000777777777777
              7000}
            OnClick = btAddFDoClick
          end
          object Label4: TLabel
            Left = 8
            Top = 20
            Width = 73
            Height = 13
            AutoSize = False
            Caption = 'Must Contain'
            Color = clBtnFace
            ParentColor = False
          end
          object btRemFDont: TSpeedButton
            Left = 453
            Top = 135
            Width = 29
            Height = 21
            Hint = 'Delete selected entry'
            Glyph.Data = {
              DE000000424DDE0000000000000076000000280000000D0000000D0000000100
              0400000000006800000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              7000777777777777700077777777777770007777777777777000777777777777
              70007700000000077000770CCCCCCC0770007700000000077000777777777777
              7000777777777777700077777777777770007777777777777000777777777777
              7000}
            OnClick = btRemFDontClick
          end
          object btAddFDont: TSpeedButton
            Left = 421
            Top = 135
            Width = 29
            Height = 21
            Hint = 'Add new entry'
            Glyph.Data = {
              DE000000424DDE0000000000000076000000280000000D0000000D0000000100
              0400000000006800000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              700077777777777770007777700077777000777770C077777000777770C07777
              7000770000C000077000770CCCCCCC077000770000C000077000777770C07777
              7000777770C07777700077777000777770007777777777777000777777777777
              7000}
            OnClick = btAddFDontClick
          end
          object Label5: TLabel
            Left = 252
            Top = 20
            Width = 101
            Height = 13
            AutoSize = False
            Caption = 'Must Never Contain'
            Color = clBtnFace
            ParentColor = False
          end
          object lbFDo: TListBox
            Left = 8
            Top = 36
            Width = 237
            Height = 97
            ItemHeight = 13
            TabOrder = 0
            OnDblClick = lbDoDblClick
          end
          object cbFAllDo: TCheckBox
            Left = 8
            Top = 140
            Width = 145
            Height = 17
            Caption = '&Must match all patterns'
            TabOrder = 1
          end
          object lbFDont: TListBox
            Left = 252
            Top = 36
            Width = 229
            Height = 97
            ItemHeight = 13
            TabOrder = 2
            OnDblClick = lbDoDblClick
          end
        end
      end
      object tbAdditional: TTabSheet
        Caption = 'Additional Filters'
        ImageIndex = 2
        object lblMaxSize: TLabel
          Left = 168
          Top = 8
          Width = 44
          Height = 13
          Caption = 'Ma&ximum'
          FocusControl = edMaxSize
        end
        object lblMinSize: TLabel
          Left = 24
          Top = 8
          Width = 81
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'M&inimum Filesize'
          FocusControl = edMinSize
        end
        object lblMegabytes: TLabel
          Left = 276
          Top = 8
          Width = 52
          Height = 13
          Caption = 'Megabytes'
          FocusControl = edMaxSize
        end
        object Bevel2: TBevel
          Left = 8
          Top = 36
          Width = 481
          Height = 2
        end
        object Label6: TLabel
          Left = 48
          Top = 76
          Width = 369
          Height = 29
          AutoSize = False
          Caption = 
            'This will keep you from picking up Episodes that have not aired ' +
            'yet ("fakes"). After a successfull download the date is automati' +
            'cally increased.'
          WordWrap = True
        end
        object Image3: TImage
          Left = 28
          Top = 76
          Width = 16
          Height = 16
          AutoSize = True
          Picture.Data = {
            07544269746D617036030000424D360300000000000036000000280000001000
            0000100000000100180000000000000300000000000000000000000000000000
            00000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF848284
            8482840000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF0000FF0000FF0000FF0000000000008482840000FF0000FF0000FF0000FF00
            00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF000000FFFFFF000000
            8482840000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF000000000000C6C3C6FFFFFF0000008482848482840000FF0000FF0000FF00
            00FF0000FF0000FF0000FF000000000000C6C3C6FFFFFFFFFFFFFFFFFFC6C3C6
            0000000000008482848482840000FF0000FF0000FF0000FF000000C6C3C6FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000084828484828400
            00FF0000FF848284FFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FF0000
            FFFFFFFFFFFFC6C3C60000008482840000FF848284C6C3C6FFFFFFFFFFFFFFFF
            FFFFFFFF848284FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000084
            8284848284FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF000000848284848284FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF848284FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000084
            8284848284FFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF000000848284848284FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000000
            00FF0000FF848284FFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFF0000008482840000FF0000FF848284FFFFFFFFFFFFFFFF
            FFFFFFFFFF0000FF0000FF0000FFFFFFFFFFFFFFFFFFC6C3C60000000000FF00
            00FF0000FF0000FF848284848284FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF0000000000000000FF0000FF0000FF0000FF0000FF0000FF0000FF8482
            848482848482848482848482848482848482840000FF0000FF0000FF0000FF00
            00FF}
          Transparent = True
        end
        object Bevel3: TBevel
          Left = 8
          Top = 116
          Width = 481
          Height = 2
        end
        object Label7: TLabel
          Left = 324
          Top = 132
          Width = 22
          Height = 13
          Caption = 'days'
        end
        object Label8: TLabel
          Left = 48
          Top = 156
          Width = 369
          Height = 29
          AutoSize = False
          Caption = 
            'This will keep you from picking up Episodes that have not aired ' +
            'yet ("fakes") and recude load on the websites you are using.'
          WordWrap = True
        end
        object Image4: TImage
          Left = 28
          Top = 156
          Width = 16
          Height = 16
          AutoSize = True
          Picture.Data = {
            07544269746D617036030000424D360300000000000036000000280000001000
            0000100000000100180000000000000300000000000000000000000000000000
            00000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF848284
            8482840000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF0000FF0000FF0000FF0000000000008482840000FF0000FF0000FF0000FF00
            00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF000000FFFFFF000000
            8482840000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF000000000000C6C3C6FFFFFF0000008482848482840000FF0000FF0000FF00
            00FF0000FF0000FF0000FF000000000000C6C3C6FFFFFFFFFFFFFFFFFFC6C3C6
            0000000000008482848482840000FF0000FF0000FF0000FF000000C6C3C6FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000084828484828400
            00FF0000FF848284FFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FF0000
            FFFFFFFFFFFFC6C3C60000008482840000FF848284C6C3C6FFFFFFFFFFFFFFFF
            FFFFFFFF848284FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000084
            8284848284FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF000000848284848284FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF848284FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000084
            8284848284FFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF000000848284848284FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000000
            00FF0000FF848284FFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFF0000008482840000FF0000FF848284FFFFFFFFFFFFFFFF
            FFFFFFFFFF0000FF0000FF0000FFFFFFFFFFFFFFFFFFC6C3C60000000000FF00
            00FF0000FF0000FF848284848284FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF0000000000000000FF0000FF0000FF0000FF0000FF0000FF0000FF8482
            848482848482848482848482848482848482840000FF0000FF0000FF0000FF00
            00FF}
          Transparent = True
        end
        object Bevel4: TBevel
          Left = 8
          Top = 192
          Width = 481
          Height = 2
        end
        object Label10: TLabel
          Left = 30
          Top = 228
          Width = 22
          Height = 13
          Caption = 'URL'
        end
        object Image6: TImage
          Left = 60
          Top = 252
          Width = 16
          Height = 16
          AutoSize = True
          Picture.Data = {
            07544269746D617036030000424D360300000000000036000000280000001000
            0000100000000100180000000000000300000000000000000000000000000000
            00000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF848284
            8482840000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF0000FF0000FF0000FF0000000000008482840000FF0000FF0000FF0000FF00
            00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF000000FFFFFF000000
            8482840000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF000000000000C6C3C6FFFFFF0000008482848482840000FF0000FF0000FF00
            00FF0000FF0000FF0000FF000000000000C6C3C6FFFFFFFFFFFFFFFFFFC6C3C6
            0000000000008482848482840000FF0000FF0000FF0000FF000000C6C3C6FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000084828484828400
            00FF0000FF848284FFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FF0000
            FFFFFFFFFFFFC6C3C60000008482840000FF848284C6C3C6FFFFFFFFFFFFFFFF
            FFFFFFFF848284FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000084
            8284848284FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF000000848284848284FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF848284FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000084
            8284848284FFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF000000848284848284FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C3C600000000
            00FF0000FF848284FFFFFFFFFFFFFFFFFFFFFFFF848284FF0000FF0000FFFFFF
            FFFFFFFFFFFFFFFFFF0000008482840000FF0000FF848284FFFFFFFFFFFFFFFF
            FFFFFFFFFF0000FF0000FF0000FFFFFFFFFFFFFFFFFFC6C3C60000000000FF00
            00FF0000FF0000FF848284848284FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF0000000000000000FF0000FF0000FF0000FF0000FF0000FF0000FF8482
            848482848482848482848482848482848482840000FF0000FF0000FF0000FF00
            00FF}
          Transparent = True
        end
        object Label11: TLabel
          Left = 80
          Top = 252
          Width = 349
          Height = 13
          AutoSize = False
          Caption = 'This will only download the newest episode, no previous ones.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object edMinSize: TEdit
          Left = 112
          Top = 4
          Width = 49
          Height = 21
          TabOrder = 0
          Text = '30'
          OnKeyPress = edSeasonKeyPress
        end
        object edMaxSize: TEdit
          Left = 220
          Top = 4
          Width = 49
          Height = 21
          TabOrder = 1
          Text = '1500'
          OnKeyPress = edSeasonKeyPress
        end
        object cbDateLimit: TCheckBox
          Left = 8
          Top = 50
          Width = 221
          Height = 17
          Caption = 'Only download Items added after the date'
          TabOrder = 2
        end
        object tpDateLimit: TDateTimePicker
          Left = 232
          Top = 48
          Width = 89
          Height = 21
          Date = 38807.037747997700000000
          Time = 38807.037747997700000000
          TabOrder = 3
        end
        object cbPause: TCheckBox
          Left = 8
          Top = 130
          Width = 221
          Height = 17
          Caption = 'Pause entry after successful download for '
          TabOrder = 4
        end
        object edPause: TComboBox
          Left = 228
          Top = 128
          Width = 93
          Height = 21
          ItemHeight = 13
          TabOrder = 5
          Text = '7'
          OnKeyPress = edSeasonKeyPress
          Items.Strings = (
            '1'
            '7'
            '14'
            '30')
        end
        object cbepguide: TCheckBox
          Left = 8
          Top = 204
          Width = 237
          Height = 17
          Caption = 'Use &EPguide.com to find the newest episode'
          TabOrder = 6
        end
        object edepguideurl: TEdit
          Left = 56
          Top = 224
          Width = 433
          Height = 21
          TabOrder = 7
        end
      end
    end
  end
  object pmPredef: TPopupMenu
    Left = 477
    Top = 5
    object PreDefItem: TMenuItem
      Caption = 'PreDefItem'
      OnClick = PreDefItemClick
    end
  end
end
