Attribute VB_Name = "CellSearchingUtility"
'<License>------------------------------------------------------------
'
' Copyright (c) 2019 Shinnosuke Yakenohara
'
' This program is free software: you can redistribute it and/or modify
' it under the terms of the GNU General Public License as published by
' the Free Software Foundation, either version 3 of the License, or
' (at your option) any later version.
'
' This program is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' GNU General Public License for more details.
'
' You should have received a copy of the GNU General Public License
' along with this program.  If not, see <http://www.gnu.org/licenses/>.
'
'-----------------------------------------------------------</License>

'
' �w��͈͓����������čŏ��Ɍ��������Z����Ԃ�
'
' ## Parameters
'
'  - keyWord
'     �Z�������L�[���[�h
'
'  - fromThisRange
'     �����Ώ۔͈�
'
'  - lookAtPart (Optional. TRUE as default)
'     Cell�����L�[���[�h `keyWord` �𕔕���v�Ō�������ꍇ�� `TRUE`
'     ���S��v�Ō�������ꍇ�� `FALSE` ���w�肷��
'
' ## Returns
'
'  �ŏ��Ɍ��������Z���� Range Object
'  �Z����������Ȃ������ꍇ�� `#N/A` ��ԋp����
'
Public Function matchedCellInRange(ByVal keyWord As Variant, ByVal fromThisRange As Range, Optional ByVal lookAtPart As Boolean = True) As Variant

    Dim ret As Variant '�ԋp�l
    Dim lookAtParam As Variant 'Range.Find method �� LookAt parameter �p�ݒ�l
    Dim rangeBrokenKeyword As Variant
    
    'Range.Find method �� LookAt parameter �p�ݒ�l�̌���
    If lookAtPart Then '������v�w��̏ꍇ
        lookAtParam = xlPart
    
    Else '���S��v�w��̏ꍇ
        lookAtParam = xlWhole
    End If
    
    
    'note
    '
    ' ���t�^�������͒ʉ݌^�̏����ݒ�������Z���� Range Object�� .Value ���Ԃ��l�̌^�́A
    ' �Z���ɐݒ肳��Ă���l�ɂ���āA�ȉ��̂悤�ɕ��G�ɕω�����B
    ' ����\�����ɂ����̂ŁABoolean/Double/String/Error/Empty �^�����Ԃ��Ȃ� .Value2 �Ŏ擾����B
    '
    ' ���t�^
    '   -> Date �^ ���AString �^(1900�N1��1��~9999�N12��31��(��1)�͈̔͊O�̓��t)
    ' �ʉ݌^
    '   -> Currency �^ ���A
    '      .Value �ɃA�N�Z�X���������� Exception(
    '        �Z���̒l�� -922,337,203,685,477 �` 922,337,203,685,477(��2) �͈̔͊O�̒l���ݒ肳��Ă����ꍇ�ɔ�������
    '      )��
    ' �Œl���擾����B
    '
    ' ��1
    ' https://support.office.com/ja-jp/article/excel-%e3%81%ae%e4%bb%95%e6%a7%98%e3%81%a8%e5%88%b6%e9%99%90-1672b34d-7043-467e-8e27-269d656771c3?ui=ja-JP&rs=ja-JP&ad=JP
    '
    ' ��2
    ' https://docs.microsoft.com/ja-jp/office/vba/language/reference/user-interface-help/data-type-summary
    '
    'Range.Value2 method �����̑���� �����L�[���[�h���擾
    rangeBrokenKeyword = getValue2(keyWord)
    
    If IsError(rangeBrokenKeyword) Then
        'note Range.Find method �� What:= �Ɏw�肷��� Exception ����������̂ŁA�n�W��
        ret = CVErr(xlErrValue) '#VALUE! ��Ԃ�
        
    Else
    
        ' Option Parameter settings of Range.Find method
        '
        '| Parameter       | Meaning                                       |
        '| --------------- | --------------------------------------------- |
        '| After           | �Z���͈͂̐擪������1���ڂ̃Z���ƂȂ�悤�ɁA |
        '|                 | �����J�n�ʒu���Z���͈͍Ō�ɂ���              |
        '| LookIn          | �����Ώۂ𐔎��Ɏw��                          |
        '| LookAt          | ���S��v / ������v (�����ݒ�ɂ��)          |
        '| SearchOrder     | �����������s�Ŏw��                            |
        '| SearchDirection | �������Ō���                                  |
        '| MatchCase       | �啶���Ə���������ʂ��Ȃ�                    |
        '| MatchByte       | ���p�ƑS�p����ʂ��Ȃ�                        |
        '| SearchFormat    | �����Ō������Ȃ�                              |
        '
        Set searchResult = fromThisRange.Find( _
            What:=keyWord, _
            After:=fromThisRange.Item(fromThisRange.Count), _
            LookIn:=xlValues, _
            LookAt:=lookAtParam, _
            SearchOrder:=xlByColumns, _
            SearchDirection:=xlNext, _
            MatchCase:=False, _
            MatchByte:=False, _
            SearchFormat:=False _
        )
        
        If Not searchResult Is Nothing Then '���������Ƃ�
            Set ret = searchResult
            
        Else '������Ȃ�������
            ret = CVErr(xlErrNA) '#N/A��ԋp
        
        End If
    
    End If
    
    If IsObject(ret) Then
        Set matchedCellInRange = ret
    Else
        matchedCellInRange = ret
    End If
    
End Function

'
' ThisWorkbook ���̎w��V�[�g����Z�����������āA
' �ŏ��Ɍ��������Z����Ԃ�
'
' ## Parameters
'
'  - keyWord
'     �Z�������L�[���[�h
'
'  - inThisSheet
'     �����ΏۃV�[�g
'     ���l�^�Ŏw�肵���ꍇ�̓V�[�g�ԍ�(1 based)
'     ������^�Ŏw�肵���ꍇ�̓V�[�g���Ƃ��Ĉ�����
'
'  - lookAtPart (Optional. TRUE as default)
'     Cell�����L�[���[�h `keyWord` �𕔕���v�Ō�������ꍇ�� `TRUE`
'     ���S��v�Ō�������ꍇ�� `FALSE` ���w�肷��
'
' ## Returns
'
'  �ŏ��Ɍ��������Z���� Range Object
'  �G���[���͈ȉ���ԋp����
'
'  - #N/A
'     �Z����������Ȃ������ꍇ
'
'  - #NUM!
'     �����ΏۃV�[�g�����݂��Ȃ��ꍇ
'
'  - #VALUE!
'     �����ΏۃV�[�g�̎w����� `inThisSheet` ��
'     ������^�ł����l�^�ł��Ȃ��^�Œl���w�肳��Ă���
'
Public Function matchedCellInSheet(ByVal keyWord As Variant, ByVal inThisSheet As Variant, Optional ByVal lookAtPart As Boolean = True) As Variant
    
    Dim ret As Variant '�ԋp�l
    Dim rangeBrokenKeyword As Variant
    Dim rangeBrokenSheetName As Variant '�����ΏۃV�[�g���w�肷��ׂ̈���
    Dim searchFromThisSheet As Variant  '�����ΏۃV�[�g
    Dim lookAtParam As Variant 'Range.Find method �� LookAt parameter �p�ݒ�l
    
    'Range.Value2 method �����̑���� �����L�[���[�h���擾
    rangeBrokenKeyword = getValue2(keyWord)
    
    If IsError(rangeBrokenKeyword) Then
        'note Range.Find method �� What:= �Ɏw�肷��� Exception ����������̂ŁA�n�W��
        ret = CVErr(xlErrValue) '#VALUE! ��Ԃ�
        
    Else
    
        'Range.Value2 method �����̑���� �V�[�g�����擾
        rangeBrokenSheetName = getValue2(inThisSheet)
        
        '�����ΏۃV�[�g�̐ݒ�
        Select Case (TypeName(rangeBrokenSheetName))
            
            Case "String" '�V�[�g���w��̏ꍇ
            
                Set searchFromThisSheet = getSheetObjFromString(rangeBrokenSheetName)
                
                If searchFromThisSheet Is Nothing Then
                    ret = CVErr(xlErrNum) '#NUM! ��Ԃ�
                End If
            
            Case "Double" 'Index No(1 based) �w��̏ꍇ
            
                '���[�N�V�[�g���`�F�b�N
                If (rangeBrokenSheetName <= ThisWorkbook.Worksheets.Count) Then '���݂��郏�[�N�V�[�g���͈͓̔��̏ꍇ
                    Set searchFromThisSheet = ThisWorkbook.Worksheets(rangeBrokenSheetName)
                
                Else '���݂��郏�[�N�V�[�g���͈̔͊O�̏ꍇ
                    ret = CVErr(xlErrNum) '#NUM! ��Ԃ�
                    
                End If
            
            Case Else '�s���^�̏ꍇ
                ret = CVErr(xlErrValue) '#VALUE! ��Ԃ�
                
        End Select
        
        If Not (IsError(ret)) Then
            
            'Range.Find method �� LookAt parameter �p�ݒ�l�̌���
            If lookAtPart Then '������v�w��̏ꍇ
                lookAtParam = xlPart
            Else '���S��v�w��̏ꍇ
                lookAtParam = xlWhole
            End If
            
            ' Option Parameter settings of Range.Find method
            '
            '| Parameter       | Meaning                                       |
            '| --------------- | --------------------------------------------- |
            '| After           | �Z���͈͂̐擪������1���ڂ̃Z���ƂȂ�悤�ɁA |
            '|                 | �����J�n�ʒu���Z���͈͍Ō�ɂ���              |
            '| LookIn          | �����Ώۂ𐔎��Ɏw��                          |
            '| LookAt          | ���S��v / ������v (�����ݒ�ɂ��)          |
            '| SearchOrder     | �����������s�Ŏw��                            |
            '| SearchDirection | �������Ō���                                  |
            '| MatchCase       | �啶���Ə���������ʂ��Ȃ�                    |
            '| MatchByte       | ���p�ƑS�p����ʂ��Ȃ�                        |
            '| SearchFormat    | �����Ō������Ȃ�                              |
            '
            Set fromThisRange = searchFromThisSheet.UsedRange
            Set foundobj = fromThisRange.Find( _
                What:=rangeBrokenKeyword, _
                After:=fromThisRange.Item(fromThisRange.Count), _
                LookIn:=xlValues, _
                LookAt:=lookAtParam, _
                SearchOrder:=xlByColumns, _
                SearchDirection:=xlNext, _
                MatchCase:=False, _
                MatchByte:=False, _
                SearchFormat:=False _
            )
            
            If (foundobj Is Nothing) Then '������Ȃ������ꍇ
                ret = CVErr(xlErrNA) '#N/A��ԋp
            Else '���������ꍇ
                Set ret = foundobj '��������Cell�� Range Object��ԋp
                
            End If
            
        End If
    End If
    
    If IsObject(ret) Then
        Set matchedCellInSheet = ret
    Else
        matchedCellInSheet = ret
    End If
    
End Function

'
' �w������� �Z���Q��(Range Object) �̏ꍇ�� .Value2 �ŃZ�����̒l���A
' �����łȂ��ꍇ�� �v���~�e�B�u�^���w�肳�ꂽ�Ɣ��f���āA
' .Value2 ����肤��l�̃^�C�v
' Double/String/Boolean/Error/Empty
' �̂��Âꂩ�� Cast ���ĕԂ�
'
Private Function getValue2(ByVal variant_unkown As Variant) As Variant

    Dim ret As Variant
    
    If (TypeName(variant_unkown) = "Range") Then
        ret = variant_unkown.Value2
    
    Else
        ret = getValue2FromPrimitive(variant_unkown)
        
    End If
    
    getValue2 = ret
    
End Function

'
' �Z�����̒l����肤��^�C�v
' Double/Currency/Date/String/Boolean/Error/Empty
' ���A.Value2 �Œl���擾���邱�ƂŁA�^�C�v��
' Double/String/Boolean/Error/Empty (Currency��Date�^��Double�ɃL���X�g�����)
' �̂��Âꂩ�� Cast �����悤�ɁA
' �v���~�e�B�u�Ȓl���i�[����ϐ�����肤��^�C�v(Decimal, Long, LongLong��)��
' Double/String/Boolean/Error/Empty
' �̂��Âꂩ�� Cast ���ĕԂ�
'
' �L���X�g�s�\�ȃ^�C�v(Object��)�̏ꍇ�� #VALUE! ��Ԃ�
'
Private Function getValue2FromPrimitive(ByVal variant_primitive As Variant) As Variant

    Dim ret As Variant '�ԋp�l
    
    On Error GoTo EXCEPTION_CAST 'CDbl() �� Exception ���� Go
    
    '
    ' Case statement ���́�
    '  VBA ��1�f�[�^�^(�g�ݍ��݂̃f�[�^�^, Intrinsic data type)�����A�v���~�e�B�u�^�Ƃ݂͂Ȃ��Ȃ�
    '
    Select Case TypeName(variant_primitive)
        Case "Boolean"
            ret = variant_primitive 'Boolean �̂܂܊i�[
        
        Case "Byte"
            ret = CDbl(variant_primitive)
        
        'Case "Collection" ->�Ή����Ȃ���
        
        Case "Currency"
            ret = CDbl(variant_primitive)
        
        Case "Date"
            ret = CDbl(variant_primitive) '�V���A���l�� Double �Ƃ��Ď擾
            
        Case "Decimal"
            ret = CDbl(variant_primitive)
        
        'Case "Dictionary" ->�Ή����Ȃ���
        
        Case "Double"
            ret = variant_primitive '���̂܂܊i�[
        
        Case "Integer"
            ret = CDbl(variant_primitive)
        
        Case "Long"
            ret = CDbl(variant_primitive)
        
        Case "LongLong"
            ret = CDbl(variant_primitive)
        
        'Case "LongPtr" ->�Ή����Ȃ���
        
        'Case "Object" ->�Ή����Ȃ���
        
        Case "Single"
            ret = CDbl(variant_primitive)
        
        Case "String" '(�ϒ�������A�Œ蒷������ǂ���ł�)
            ret = variant_primitive '���̂܂܊i�[
            
        Case Else
            
            If _
            ( _
                (IsError(variant_primitive)) Or _
                (IsEmpty(variant_primitive)) _
            ) Then
                'Error ��Empty�̏ꍇ�͂��̂܂ܕԂ�
                ret = variant_primitive
            Else
                ret = CVErr(xlErrValue) '#VALUE! ��Ԃ�
            End If
            
        
    End Select
    
    getValue2FromPrimitive = ret
    Exit Function
    
EXCEPTION_CAST: 'CDbl() �� Exception����

    ret = CVErr(xlErrValue) '#VALUE! ��Ԃ�
    getValue2FromPrimitive = ret
    Exit Function
    
End Function

'
' ThisWorkbook ���� Sheet Object �� �V�[�g�����g���Ď擾����
' �V�[�g�����݂��Ȃ��ꍇ�́ANothing ��Ԃ�
'
Private Function getSheetObjFromString(ByVal sheetName As String) As Variant
    
    Dim ret As Variant
    
    On Error GoTo NOT_FOUND
    Set getSheetObjFromString = ThisWorkbook.Worksheets(sheetName)
    Exit Function
    
NOT_FOUND: ' �V�[�g�����݂��Ȃ��ꍇ
    Set getSheetObjFromString = Nothing
    Exit Function
    
End Function
