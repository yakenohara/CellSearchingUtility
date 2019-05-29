Attribute VB_Name = "CellSearchingUtility"
'
' �w��V�[�g�Ɉ�v����Z�������݂��邩�ǂ�����Ԃ�
'
' findThis: �����L�[���[�h
' inThisSheetName: �����V�[�g��
' lookAtPart: True �ŕ�����v�w��, false �Ŋ��S��v�w��
'
Public Function isDefinedInThisSheet(ByVal findThis As Variant, ByVal inThisSheetName As Variant, Optional ByVal lookAtPart As Variant = True) As Variant
    
    Dim ret As Variant
    Dim sheetWasFound As Boolean '�V�[�g�������������ǂ���
    Dim cellWasFound As Boolean '�����������ǂ���
    Dim lookAtParam As Variant 'Range.Find method �� LookAt parameter �p�ݒ�l
    
    'Range.Find method �� LookAt parameter �p�ݒ�l�̌���
    If lookAtPart Then '���S��v�w��̏ꍇ
        lookAtParam = xlPart
    
    Else '���S��v�w��łȂ��ꍇ
        lookAtParam = xlWhole
    
    End If
    
    
    '�f�t�H���g��`������Ȃ�����`��ݒ�
    sheetWasFound = False
    cellWasFound = False
    
    '�V�[�g�ԗ����[�v
    For Each sht In Worksheets
        
        If sht.Name = inThisSheetName Then '�w��V�[�g�����������ꍇ
        
            sheetWasFound = True
        
            Set foundobj = sht.UsedRange.Find( _
                What:=findThis, _
                LookAt:=lookAtParam _
            )
            
            If Not (foundobj Is Nothing) Then '���������ꍇ
                cellWasFound = True
            
            End If
            
            Exit For 'break
        
        End If
        
    Next sht
    
    If Not sheetWasFound Then '�V�[�g��������Ȃ������ꍇ
        ret = CVErr(xlErrNA) '#N/A��Ԃ�
    
    Else
        ret = cellWasFound '�Z����������Ȃ��������ǂ�����Ԃ�
    
    End If
    
    isDefinedInThisSheet = ret
    
End Function

'
'�w�蕶������������ăq�b�g�����Z���̈ʒu��Ԃ�
'
' findThis: �����L�[���[�h
' searchRange: �����Ώ۔͈�
' getRow: True �q�b�g�����Z���̈ʒu�̍s���w��, False�ŗ�w��
' lookAtPart: True �ŕ�����v�w��, false �Ŋ��S��v�w��
'
Public Function findCellAndGetPosition(ByVal findThis As Variant, ByVal searchRange As Range, ByVal getRow As Variant, Optional ByVal lookAtPart As Variant = True) As Variant

    Dim ret As Variant
    Dim lookAtParam As Variant 'Range.Find method �� LookAt parameter �p�ݒ�l
    
    'Range.Find method �� LookAt parameter �p�ݒ�l�̌���
    If lookAtPart Then '���S��v�w��̏ꍇ
        lookAtParam = xlPart
    
    Else '���S��v�w��łȂ��ꍇ
        lookAtParam = xlWhole
    
    End If
    
    '�������s
    Set searchResult = searchRange.Find( _
        What:=findThis, _
        LookAt:=lookAtParam _
    )
    'xlPart:������v�L��
    'After:�擪����J�n����悤�ɁA�ŏI�Z�����w��

    If Not searchResult Is Nothing Then '���������Ƃ�
        
        If getRow Then '�s�ʒu�擾�w��̂Ƃ�
            ret = searchResult.Row
            
        Else '��ʒu�擾�w��̂Ƃ�
            ret = searchResult.Column
        
        End If
        
        
    Else '������Ȃ�������
        ret = CVErr(xlErrNA) '#N/A��ԋp
    
    End If
    
    findCellAndGetPosition = ret
    
End Function

