function varargout = testUI(varargin)
% TESTUI MATLAB code for testUI.fig
%      TESTUI, by itself, creates a new TESTUI or raises the existing
%      singleton*.
%
%      H = TESTUI returns the handle to a new TESTUI or the handle to
%      the existing singleton*.
%
%      TESTUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTUI.M with the given input arguments.
%
%      TESTUI('Property','Value',...) creates a new TESTUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testUI

% Last Modified by GUIDE v2.5 07-May-2017 22:25:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testUI_OpeningFcn, ...
                   'gui_OutputFcn',  @testUI_OutputFcn, ...
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


% --- Executes just before testUI is made visible.
function testUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testUI (see VARARGIN)

% Choose default command line output for testUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function PictureOpen_Callback(hObject, eventdata, handles)
% hObject    handle to PictureOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global image_src;
global image_dst;
global strokeWidth;
global gammaS;
global gammaI;
global flag;

flag=0;

[filename,pathname]=uigetfile(...                                          %省略号表述续行
{'*.bmp;*.jpg;*.png;*.jpeg;*.tif;*.gif','All Image File';...
 '*.*','All Files'},...
 'Pick an Image');

if ~isequal(filename,0)
    axes(handles.axes_src);                                                    %用axes命令设定当前操作的坐标轴是axes_src
    fpath=[pathname filename];                                                 %将文件名和目录名组合成一个完整的路径
    image_src=imread(fpath);
    imshow(image_src);                                                         %用imread读入图片，并用imshow在axes_src上显示
    strokeWidth=1;                                                             %初始化画笔宽度
    gammaS=1.0;                                                                %初始化画笔暗度
    gammaI=1.0;                                                                %初始化图像暗度
    image_dst=PencilDrawing(image_src,8,strokeWidth,8,gammaS,gammaI);
    axes(handles.axes_dst);
    imshow(image_dst);
else
    disp('Picture openning failed!');
end

% --------------------------------------------------------------------
function PictureSave_Callback(hObject, eventdata, handles)
% hObject    handle to PictureSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%doc uiputfile

[filename,pathname]=uiputfile({'*.bmp;*.jpg;*.png;*.jpeg;*.tif;*.gif','All Image Files';...
          '*.*','All Files' },'Save a Image',...
          'D:\unnamed.jpg');
if ~isequal(filename,0)
    fpath = [pathname filename];
    image=getimage(gcf);
    imwrite(image,fpath,'jpg');
else
    disp('Picture saving failed!');
end


% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;


% --- Executes on slider movement.
function sliderStrokeWidth_Callback(hObject, eventdata, handles)
% hObject    handle to sliderStrokeWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global image_src;
global image_dst;
global strokeWidth;
global gammaS;
global gammaI;
strokeWidth=get(hObject,'Value');
image_dst=PencilDrawing(image_src,8,strokeWidth,8,gammaS,gammaI);
axes(handles.axes_dst);
imshow(image_dst);


% --- Executes during object creation, after setting all properties.
function sliderStrokeWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderStrokeWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',1.0);                                                  %strokeWidth的初始值为1.0，设置与之对应的滑块初始位置



% --- Executes on slider movement.
function sliderGammaS_Callback(hObject, eventdata, handles)
% hObject    handle to sliderGammaS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global image_src;
global image_dst;
global strokeWidth;
global gammaS;
global gammaI;
gammaS=get(hObject,'Value');
image_dst=PencilDrawing(image_src,8,strokeWidth,8,gammaS,gammaI);
axes(handles.axes_dst);
imshow(image_dst);


% --- Executes during object creation, after setting all properties.
function sliderGammaS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderGammaS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',1.0);                                                  %设置于gammaS变量对用的滑块的初始位置


% --- Executes on slider movement.
function sliderGammaI_Callback(hObject, eventdata, handles)
% hObject    handle to sliderGammaI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global image_src;
global image_dst;
global strokeWidth;
global gammaS;
global gammaI;
gammaI=get(hObject,'Value');
image_dst=PencilDrawing(image_src,8,strokeWidth,8,gammaS,gammaI);
axes(handles.axes_dst);
imshow(image_dst);


% --- Executes during object creation, after setting all properties.
function sliderGammaI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderGammaI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',1.0);                                                  %设置于gammaI变量对用的滑块的初始位置


% --- Executes during object creation, after setting all properties.
function axes_src_CreateFcn(hObject, eventdata, handles)                   %为显示原图像创建坐标系
% hObject    handle to axes_src (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_src

set(hObject,'xTick',[]);                                                   %不显示坐标系的坐标刻度
set(hObject,'yTick',[]);


% --- Executes during object creation, after setting all properties.
function axes_dst_CreateFcn(hObject, eventdata, handles)                   %为显示处理后的图像创建坐标系
% hObject    handle to axes_dst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_dst

set(hObject,'xTick',[]);
set(hObject,'yTick',[]);


% --------------------------------------------------------------------
function uipushtoolPictureOpen_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtoolPictureOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PictureOpen_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function uipushtoolPictureSave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtoolPictureSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PictureSave_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function uitoggletoolZoomOut_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletoolZoomOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global flag;
flag=1-flag;                                                               %通过flag变量来实现放大功能的切换
h=zoom;
if isequal(flag,1)
    set(h,'Enable','on');
else
    set(h,'Enable','off');
end


% --------------------------------------------------------------------
function Demo_Callback(hObject, eventdata, handles)
% hObject    handle to Demo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Begin_Callback(hObject, eventdata, handles)
% hObject    handle to Begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

path_image_src=uigetdir;                                                   %可以手动选择需要读取的文件夹
path_image_dst=strrep(path_image_src,'inputs','results');                  %strrep为字符串替换函数
file_src=dir(fullfile(path_image_src,'*.jpg'));
numFiles=length(file_src);
global delay;
delay=0;
for i=1:numFiles
    image_src=imread(strcat([path_image_src,'\'],file_src(i).name));
    image_dst=imread(strcat([path_image_dst,'\'],file_src(i).name));
    axes(handles.axes_src);
    imshow(image_src);
    axes(handles.axes_dst);
    imshow(image_dst);
    while isequal(delay,1)
        pause(0.1);
    end
    pause(0.8);
end

%设置一个默认路径
% files=dir(fullfile('F:\计算机视觉\PencilDrawing-master\PencilDrawing-master\inputs','*.jpg'));
% numFiles=length(files);
% for i=1:numFiles
%     img_src=imread(strcat('F:\计算机视觉\PencilDrawing-master\PencilDrawing-master\inputs\',files(i).name));
%     img_dst=imread(strcat('F:\计算机视觉\PencilDrawing-master\PencilDrawing-master\results\',strrep(files(i).name,'jpg','png')));
%     axes(handles.axes_src);
%     imshow(img_src);
%     axes(handles.axes_dst);
%     imshow(img_dst);
%     pause(1);
% end


% --------------------------------------------------------------------
function Pause_Callback(hObject, eventdata, handles)
% hObject    handle to Pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global delay;
delay=1;


% --------------------------------------------------------------------
function Continue_Callback(hObject, eventdata, handles)
% hObject    handle to Continue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global delay;
delay=0;
