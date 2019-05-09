function varargout = desensitize(varargin)
% DESENSITIZE MATLAB code for desensitize.fig
%      DESENSITIZE, by itself, creates a new DESENSITIZE or raises the existing
%      singleton*.
%
%      H = DESENSITIZE returns the handle to a new DESENSITIZE or the handle to
%      the existing singleton*.
%
%      DESENSITIZE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DESENSITIZE.M with the given input arguments.
%
%      DESENSITIZE('Property','Value',...) creates a new DESENSITIZE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before desensitize_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to desensitize_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help desensitize

% Last Modified by GUIDE v2.5 09-May-2019 02:00:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @desensitize_OpeningFcn, ...
                   'gui_OutputFcn',  @desensitize_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before desensitize is made visible.
function desensitize_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to desensitize (see VARARGIN)

% Choose default command line output for desensitize
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes desensitize wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = desensitize_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_name = uigetdir;
if folder_name ~= 0
    fileFolder = fullfile(folder_name);
    dirOutput = dir(fullfile(fileFolder,'*.dcm'));
    fileNames = {dirOutput.name}';
    set(handles.listbox1,'string',fileNames);
    set(handles.pushbutton1,'UserData',fileFolder);
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fileFolder = get(handles.pushbutton1,'UserData');
dirOutput = dir(fullfile(fileFolder,'*.dcm'));
fileNames = {dirOutput.name}';
fileNums = length(fileNames);
if fileNums == 0
    errordlg('该文件夹下没有DCM文件，请重新选择！','错误');
else
    newfiledir = uigetdir;
    if newfiledir ~= 0
        for i=1:1:fileNums
            newfilename = [newfiledir,'\',fileNames{i}(1:end-4),'_desensitized.dcm'];
            metadata = dicominfo([fileFolder,'\',fileNames{i}]);
            X = dicomread(metadata);
            metadata.PatientAge = '*';
            metadata.PatientBirthDate = '********';
            metadata.PatientID = '****';
            metadata.PatientName.FamilyName = '***';
            metadata.PatientSex = '*';
            dicomwrite(X, newfilename, metadata);
        end
    end
    msgbox('脱敏已完成！','已完成');
    winopen(newfiledir);
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
