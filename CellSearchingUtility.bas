Attribute VB_Name = "Module1"
'
' �w��V�[�g�Ɉ�v����Z�������݂��邩�ǂ�����Ԃ�
'
' findThis: ��������Z��
' inThisSheetName: �����V�[�g��
' lookAtPart: True �ŕ�����v�w��, false �Ŋ��S��v�w��
'
' Parameters of Range.Find method
'
' | Argment         | Constant    | Description                    |
' | --------------- | ----------- | ------------------------------ |
' | What            | -           | ��������f�[�^���w��(�K�{)     |
' | After           | -           | �������J�n����Z�����w��       |
' | LookIn          | xlFormulas  | �����Ώۂ𐔎��Ɏw��           |
' |                 | xlValues    | �����Ώۂ�l�Ɏw��             |
' |                 | xlComents   | �����Ώۂ��R�����g���Ɏw��     |
' | LookAt          | xlPart      | �ꕔ����v����Z��������       |
' |                 | xlWhole     | �S������v����Z��������       |
' | SearchOrder     | xlByRows    | �����������Ŏw��             |
' |                 | xlByColumns | �����������s�Ŏw��             |
' | SearchDirection | xlNext      | �������Ō���(�f�t�H���g�̐ݒ�) |
' |                 | xlPrevious  | �t�����Ō���                   |
' | MatchCase       | True        | �啶���Ə����������           |
' |                 | False       | ��ʂ��Ȃ�(�f�t�H���g�̐ݒ�)   |
' | MatchByte       | True        | ���p�ƑS�p����ʂ���           |
' |                 | False       | ��ʂ��Ȃ�(�f�t�H���g�̐ݒ�)   |
'
' Parameters of Range.Find method
'
' | Constant   | Number | Display | Desctiption                                                                              |
' | ---------- | -----: | ------- | ---------------------------------------------------------------------------------------- |
' | xlErrDiv0  |   2007 | #DIV/0! | 0����                                                                                    |
' | XlErrNA    |   2042 | #N/A    | �v�Z�⏈���̑ΏۂƂȂ�f�[�^���Ȃ��A�܂��͐����Ȍ��ʂ������Ȃ�                         |
' | xlErrName  |   2029 | #NAME?  | Excel�̊֐��ł͗��p�ł��Ȃ����O(���݂��Ȃ��֐�����)���g�p����Ă���                      |
' | XlErrNull  |   2000 | #NULL!  | ���p�󔒕����̎Q�Ɖ��Z�q�Ŏw�肵��2�̃Z���͈͂ɁA���ʕ������Ȃ�(`=SUM(A1:A3 C1:C3)`��) |
' | XlErrNum   |   2036 | #NUM!   | �g�p�ł���͈͊O�̐��l���w�肵�����A���ꂪ�����Ŋ֐��̉���������Ȃ�                   |
' | XlErrRef   |   2023 | #REF!   | �������Ŗ����ȃZ�����Q�Ƃ���Ă���                                                       |
' | XlErrValue |   2015 | #VALUE! | �֐��̈����̌`�����Ԉ���Ă���(���l���w�肷�ׂ��Ƃ���ɕ�������w�蓙)                   |
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
        
            '���S��v�Ō���
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
