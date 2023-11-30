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

'<note>------------------------------------------------------------------------------------------------------------------------
'
' Range.Value method �ł͂Ȃ� Range.Value2 method ���g�p���闝�R
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
'-----------------------------------------------------------------------------------------------------------------------</note>

'
' �w��͈͓����������čŏ��Ɍ��������Z����Ԃ�
'
' ## Parameters
'
'  - keyWord
'      �Z�������L�[���[�h
'  - fromThisRange
'      �����Ώ۔͈�
'
' ## Returns
'
'  �ŏ��Ɍ��������Z���� Range Object
'  �Z����������Ȃ������ꍇ�� `#N/A` ��ԋp����
'
Public Function matchedCellInRange(ByVal keyWord As Variant, ByVal fromThisRange As Range) As Variant

    Dim ret As Variant '�ԋp�l
    Dim primitiveKeyword As Variant
    Dim foundCell As Range
    
    'Range.Value2 method �����̑���� �v���~�e�B�u�Ȍ����L�[���[�h���擾
    primitiveKeyword = getValue2(keyWord)
    
    '����
    Set foundCell = findCellByColumn(primitiveKeyword, fromThisRange)
    
    If foundCell Is Nothing Then '������Ȃ�������
        ret = CVErr(xlErrNA) '#N/A��ԋp
        
    Else '���������Ƃ�
        Set ret = foundCell
    
    End If
    
    '�ԋp�l���i�[���ďI��
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
'  - inThisSheet
'     �����ΏۃV�[�g
'     ���l�^�Ŏw�肵���ꍇ�̓V�[�g�ԍ�(1 based)
'     ������^�Ŏw�肵���ꍇ�̓V�[�g���Ƃ��Ĉ�����
'
' ## Returns
'
'  �ŏ��Ɍ��������Z���� Range Object
'  �G���[���͈ȉ���ԋp����
'
'  - #N/A
'     �Z����������Ȃ������ꍇ
'  - #NUM!
'     �����ΏۃV�[�g�����݂��Ȃ��ꍇ
'  - #VALUE!
'     �����ΏۃV�[�g�̎w����� `inThisSheet` ��
'     ������^�ł����l�^�ł��Ȃ��^�Œl���w�肳��Ă���
'
Public Function matchedCellInSheet(ByVal keyWord As Variant, ByVal inThisSheet As Variant) As Variant
    
    Dim ret As Variant '�ԋp�l
    Dim primitiveKeyword As Variant
    Dim primitiveSheetName As Variant '�����ΏۃV�[�g���w�肷��ׂ̈���
    Dim searchFromThisSheet As Variant  '�����ΏۃV�[�g
    Dim foundCell As Range
    
    'Range.Value2 method �����̑���� �����L�[���[�h���擾
    primitiveKeyword = getValue2(keyWord)
    
    'Range.Value2 method �����̑���� �V�[�g�����擾
    primitiveSheetName = getValue2(inThisSheet)
    
    '�����ΏۃV�[�g�̐ݒ�
    Set searchFromThisSheet = Nothing '�����ΏۃV�[�g��������Ԃ�ݒ�(�G�����o�̈�)
    Select Case (TypeName(primitiveSheetName))
        
        Case "String" '�V�[�g���w��̏ꍇ
        
            Set searchFromThisSheet = getSheetObjFromString(primitiveSheetName)
            
            If searchFromThisSheet Is Nothing Then
                ret = CVErr(xlErrNum) '#NUM! ��Ԃ�
            End If
        
        Case "Double" 'Index No(1 based) �w��̏ꍇ
        
            '���[�N�V�[�g���`�F�b�N
            If (primitiveSheetName <= ThisWorkbook.Worksheets.Count) Then '���݂��郏�[�N�V�[�g���͈͓̔��̏ꍇ
                Set searchFromThisSheet = ThisWorkbook.Worksheets(primitiveSheetName)
            
            Else '���݂��郏�[�N�V�[�g���͈̔͊O�̏ꍇ
                ret = CVErr(xlErrNum) '#NUM! ��Ԃ�
                
            End If
        
        Case Else '�s���^�̏ꍇ
            ret = CVErr(xlErrValue) '#VALUE! ��Ԃ�
            
    End Select
    
    If Not (searchFromThisSheet Is Nothing) Then '�����ΏۃV�[�g������ꍇ
        '����
        Set foundCell = findCellByColumn(primitiveKeyword, searchFromThisSheet.UsedRange)
        
        If foundCell Is Nothing Then '������Ȃ�������
            ret = CVErr(xlErrNA) '#N/A��ԋp
            
        Else '���������Ƃ�
            Set ret = foundCell
        
        End If
        
    End If
    
    '�ԋp�l���i�[���ďI��
    If IsObject(ret) Then
        Set matchedCellInSheet = ret
    Else
        matchedCellInSheet = ret
    End If
    
End Function

'
' ThisWorkbook ���̎w��V�[�g����V�F�C�v���������āA
' �����������ǂ����� Bool �ŕԂ�
'
' ## Parameters
'
'  - keyWord
'     �Z�������L�[���[�h
'  - inThisSheet
'     �����ΏۃV�[�g
'     ���l�^�Ŏw�肵���ꍇ�̓V�[�g�ԍ�(1 based)
'     ������^�Ŏw�肵���ꍇ�̓V�[�g���Ƃ��Ĉ�����
'
' ## Returns
'
'  �ŏ��Ɍ����������ǂ����� Bool �l
'  �G���[���͈ȉ���ԋp����
'
'  - #NUM!
'     �����ΏۃV�[�g�����݂��Ȃ��ꍇ
'  - #VALUE!
'     �����ΏۃV�[�g�̎w����� `inThisSheet` ��
'     ������^�ł����l�^�ł��Ȃ��^�Œl���w�肳��Ă���
'
Public Function isThereMatchedShapeInSheet(ByVal keyWord As String, ByVal inThisSheet As Variant)
    
    Dim ret As Variant '�ԋp�l
    Dim primitiveKeyword As Variant
    Dim primitiveSheetName As Variant '�����ΏۃV�[�g���w�肷��ׂ̈���
    Dim searchFromThisSheet As Variant  '�����ΏۃV�[�g
    Dim foundCell As Range
    
    'Range.Value2 method �����̑���� �����L�[���[�h���擾
    primitiveKeyword = keyWord
    
    'Range.Value2 method �����̑���� �V�[�g�����擾
    primitiveSheetName = getValue2(inThisSheet)
    
    '�����ΏۃV�[�g�̐ݒ�
    Set searchFromThisSheet = Nothing '�����ΏۃV�[�g��������Ԃ�ݒ�(�G�����o�̈�)
    Select Case (TypeName(primitiveSheetName))
        
        Case "String" '�V�[�g���w��̏ꍇ
        
            Set searchFromThisSheet = getSheetObjFromString(primitiveSheetName)
            
            If searchFromThisSheet Is Nothing Then
                ret = CVErr(xlErrNum) '#NUM! ��Ԃ�
            End If
        
        Case "Double" 'Index No(1 based) �w��̏ꍇ
        
            '���[�N�V�[�g���`�F�b�N
            If (primitiveSheetName <= ThisWorkbook.Worksheets.Count) Then '���݂��郏�[�N�V�[�g���͈͓̔��̏ꍇ
                Set searchFromThisSheet = ThisWorkbook.Worksheets(primitiveSheetName)
            
            Else '���݂��郏�[�N�V�[�g���͈̔͊O�̏ꍇ
                ret = CVErr(xlErrNum) '#NUM! ��Ԃ�
                
            End If
        
        Case Else '�s���^�̏ꍇ
            ret = CVErr(xlErrValue) '#VALUE! ��Ԃ�
            
    End Select
    
    If Not (searchFromThisSheet Is Nothing) Then '�����ΏۃV�[�g������ꍇ
        '����
        Set ret = searchShapeString(searchFromThisSheet.Shapes, primitiveKeyword)
        
        If ret Is Nothing Then '������Ȃ�������
            ret = False
        
        Else '����������
            ret = True
            
        End If
        
    End If
    
    '�ԋp�l���i�[���ďI��
    If IsObject(ret) Then
        Set isThereMatchedShapeInSheet = ret
    Else
        isThereMatchedShapeInSheet = ret
    End If
    
End Function

' todo �Ή������r���[
'
' �w�肳�ꂽ�Z�����牺�����Ɍ������čŏ��Ɍ���������ł͂Ȃ��Z����Ԃ�
' ���݂��Ȃ��ꍇ�� `Nothing` ��Ԃ�
public Function func_searchLatestCell(ByVal rng_startFromThis As Range) As Variant

    Dim rng_toRet As Variant ' �ԋp�l

    If rng_startFromThis.Row = Rows.Count Then ' �ŏI�s���w�肳�ꂽ�ꍇ
        rng_toRet = CVErr(xlErrNA) ' `#N/A` ��Ԃ�
        
    Else '�ŏI�s�ȊO���w�肳�ꂽ�ꍇ
    
        Set rng_offset1Row = rng_startFromThis.Offset(1, 0) ' 1 �s���̃Z�����擾
    
        If TypeName(rng_offset1Row.Value) = "Empty" Then ' 1 �s���̃Z�����󔒂̏ꍇ
            Set rng_tmp = rng_startFromThis.End(xlDown) ' �L�[�{�[�h����� Ctrl + �� �Ɠ����̑���ŃZ�����擾
            
            If TypeName(rng_tmp.Value) = "Empty" Then '�󔒃Z���̏ꍇ
                rng_toRet = CVErr(xlErrNA) ' `#N/A` ��Ԃ�
                
            Else ' �󔒃Z���ł͂Ȃ��ꍇ
                Set rng_toRet = rng_tmp
                
            End If
        
        Else ' 1 �s���̃Z�����󔒂ł͂Ȃ��ꍇ
            Set rng_toRet = rng_offset1Row
        
        End If
        
    End If
    
    if IsError(rng_toRet) then ' ������Ȃ������ꍇ
        func_searchLatestCell = rng_toRet
    else ' ���������ꍇ
        Set func_searchLatestCell = rng_toRet
    end if
    
End Function


'
'Shapes ���� Shepe �ŁA�e�L�X�g����v�����ŏ��� Shape ��Ԃ�
'������Ȃ��������́A Nothing ��Ԃ�
'
Private Function searchShapeString(ByVal sps As Object, ByVal txt As String) As Variant

    Dim sp  As Shape
    Dim s   As String
    Dim ret As Variant
    Dim pos As Long

    Set ret = Nothing
    For Each sp In sps
        If (sp.Type = msoGroup) Then
            Set ret = searchShapeString(sp.GroupItems, txt)
            If Not (ret Is Nothing) Then
                GoTo ExitFunction
            End If

        ElseIf (sp.Type = msoComment) Then
            GoTo CONTINUE

'TextFrame2�������Ȃ�Shape������Έȉ��̂悤�ɏ��O����
'        ElseIf (sp.Type = msoGraphic) Then
'            GoTo CONTINUE

        Else
            If (sp.TextFrame2.HasText = msoTrue) Then
                If (sp.TextFrame2.TextRange.Text = txt) Then ' ����������
                    Set ret = sp
                    GoTo ExitFunction
                
                End If
                
            End If
        End If
CONTINUE:
    Next

ExitFunction:
    Set searchShapeString = ret

End Function

'<Common>------------------------------------------------------------------------------------------------------------------------

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
'�Z���͈͂�����(�s����)���ăq�b�g�����Z����Ԃ�
'
Private Function findCellByColumn(ByVal keyWord As Variant, ByVal fromThisRange As Range) As Range

    Dim ret As Range
    Dim variant_2d_arr As Variant
    Dim long_lower_index_1d As Long
    Dim long_upper_index_1d As Long
    Dim long_lower_index_2d As Long
    Dim long_upper_index_2d As Long
    Dim long_index_1d As Long
    Dim long_index_2d As Long
    Dim string_keyword_type As String
    Dim variant_tmp As Variant
    Dim wasFound As Boolean
    
    If fromThisRange.Count = 1 Then '�����ΏۃZ����1�����̏ꍇ
        
        ReDim variant_2d_arr(1, 1) '1�����̗v�f��������2�����z��Ƃ��Ē�`
        variant_2d_arr(1, 1) = range_to_search.Value2
    Else
        
        '�����Ώ۔͈͂�UsedRange���Ɏ��܂�悤�Ƀg���~���O����2�����z��
        Set range_to_search = trimWithUsedRange(fromThisRange)
        variant_2d_arr = range_to_search.Value2
        
    End If
    
    long_lower_index_1d = LBound(variant_2d_arr, 1)
    long_upper_index_1d = UBound(variant_2d_arr, 1)
    long_lower_index_2d = LBound(variant_2d_arr, 2)
    long_upper_index_2d = UBound(variant_2d_arr, 2)
    
    string_keyword_type = TypeName(keyWord)
    
    wasFound = False
    
    For long_index_1d = long_lower_index_1d To long_upper_index_1d
    
        For long_index_2d = long_lower_index_2d To long_upper_index_2d
            
            variant_tmp = variant_2d_arr(long_index_1d, long_index_2d)
            
            If (TypeName(variant_tmp) = string_keyword_type) Then
            
                If (variant_tmp = keyWord) Then
                    wasFound = True
                    GoTo SEARCH_END
                    
                End If
                
            End If
        
        Next long_index_2d
    
    Next long_index_1d
    
SEARCH_END:
    
    If wasFound Then
        Set ret = range_to_search.Parent.Cells( _
            range_to_search.Item(1).Row + long_index_1d - 1, _
            range_to_search.Item(1).Column + long_index_2d - 1 _
        )

    Else
        Set ret = Nothing
    End If
    
    Set findCellByColumn = ret

End Function

'
' �Z���Q�Ɣ͈͂� UsedRange �͈͂Ɏ��܂�悤�Ƀg���~���O����
'
Private Function trimWithUsedRange(ByVal rangeObj As Range) As Range

    'variables
    Dim ret As Range
    Dim long_bottom_right_row_idx_of_specified As Long
    Dim long_bottom_right_col_idx_of_specified As Long
    Dim long_bottom_right_row_idx_of_used As Long
    Dim long_bottom_right_col_idx_of_used As Long

    '�w��͈͂̉E���ʒu�̎擾
    long_bottom_right_row_idx_of_specified = rangeObj.Item(1).Row + rangeObj.Rows.Count - 1
    long_bottom_right_col_idx_of_specified = rangeObj.Item(1).Column + rangeObj.Columns.Count - 1
    
    'UsedRange�̉E���ʒu�̎擾
    With rangeObj.Parent.UsedRange
        long_bottom_right_row_idx_of_used = .Item(1).Row + .Rows.Count - 1
        long_bottom_right_col_idx_of_used = .Item(1).Column + .Columns.Count - 1
    End With
    
    '�g���~���O
    Set ret = rangeObj.Parent.Range( _
        rangeObj.Item(1), _
        rangeObj.Parent.Cells( _
            IIf(long_bottom_right_row_idx_of_specified > long_bottom_right_row_idx_of_used, long_bottom_right_row_idx_of_used, long_bottom_right_row_idx_of_specified), _
            IIf(long_bottom_right_col_idx_of_specified > long_bottom_right_col_idx_of_used, long_bottom_right_col_idx_of_used, long_bottom_right_col_idx_of_specified) _
        ) _
    )
    
    '�i�[���ďI��
    Set trimWithUsedRange = ret
    
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

'-----------------------------------------------------------------------------------------------------------------------</Common>
