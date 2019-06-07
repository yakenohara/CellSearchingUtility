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
    Dim rangeBrokenSheetName As Variant '�����ΏۃV�[�g���w�肷��ׂ̈���
    Dim searchFromThisSheet As Variant  '�����ΏۃV�[�g
    Dim lookAtParam As Variant 'Range.Find method �� LookAt parameter �p�ݒ�l
    
    '�����ΏۃV�[�g `inThisSheet` �̎w�肪 Range Object �̏ꍇ�́A
    'inThisSheet.value �ŃV�[�g����������
    If (TypeName(inThisSheet)) = "Range" Then '�Z���͈͎w��̏ꍇ(1�����̃Z���I���̏ꍇ�������ŏ�������)
        rangeBrokenSheetName = inThisSheet.Item(1).Value '1�߂̃Z�����̒l
    Else
        If IsObject(inThisSheet) Then
            Set rangeBrokenSheetName = inThisSheet
        Else
            rangeBrokenSheetName = inThisSheet
        End If
    End If
    
    
    '�����ΏۃV�[�g�̐ݒ�
    Select Case (TypeName(rangeBrokenSheetName))
        
        Case "String" '�V�[�g���w��̏ꍇ
        
            Set searchFromThisSheet = getSheetObjFromString(rangeBrokenSheetName)
            
            If searchFromThisSheet Is Nothing Then
                ret = CVErr(xlErrNum) '#NUM! ��Ԃ�
            End If
        
        Case "Byte", "Integer", "Long", "Single", "Double" 'Index No(1 based) �w��̏ꍇ
        
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
        
        If (foundobj Is Nothing) Then '������Ȃ������ꍇ
            ret = CVErr(xlErrNA) '#N/A��ԋp
        Else '���������ꍇ
            Set ret = foundobj '��������Cell�� Range Object��ԋp
            
        End If
        
    End If
    
    If IsObject(ret) Then
        Set matchedCellInSheet = ret
    Else
        matchedCellInSheet = ret
    End If
    
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
