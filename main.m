prompt = {'Enter image name:','Enter image extention:'};
dlg_title = 'CVI';
num_lines = 1;
defaultans = {'moedas2','jpg'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
if strcmp(answer,{})
    msgbox('Invalid Value', 'Error','error');
    'lolol'
end
str = strcat(answer(1),'.',answer(2))