Attribute VB_Name = "Module1"
'
' �w��V�[�g�Ɉ�v����Z�������݂��邩�ǂ�����Ԃ�
'
' findThis: ��������Z��
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
