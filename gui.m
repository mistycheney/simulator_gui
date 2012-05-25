function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 18-Apr-2012 23:03:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_OpeningFcn, ...
    'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

set(handles.true_map,'XLim',[0 1],'YLim',[0 1]);
set(handles.est_map,'XLim',[0 1],'YLim',[0 1]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

handles.params.fov = 240;
handles.params.max_range = 10;
handles.params.np = 680;
% params.nt = 200;

data = load('true_lines.mat');
handles.true_lines = data.true_lines;
set(handles.truemap_text, 'String', num2str([handles.true_lines.polar]));

handles.true_pose = [0.4;0.5;1];
handles.pose = handles.true_pose;
handles.velocity = [0; 0; 0];
% handles.velocity = [0.05; 0.05; 0.1];

handles.map = build_line();
handles.P = zeros(3);

guidata(hObject, handles);

% T = 3;

cla(handles.true_map);
axes(handles.true_map);

view_linemap(handles.true_lines, handles.true_pose);

% --- Executes on button press in next_button.
function next_button_Callback(hObject, eventdata, handles)
% hObject    handle to next_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% close all

handles = guidata(hObject);

pose = handles.pose;
params = handles.params;
map = handles.map;
P = handles.P;

var_rho = 0.000001;
var_rho_theta = 0;
var_theta = 0;
Q = [var_rho var_rho_theta;
    var_rho_theta var_theta];

d = generate_sensor(params, handles.true_pose, handles.true_lines, Q);
cloud_local = rad2cart_robot_centric(d, params.fov)';
cloud_local = remove_zeros(cloud_local);

map_local = extract_line(cloud_local, Q);
%     delta_pose = scan_matching_line(map_local, map, pose);

vel_x = get(handles.velx_slider,'Value');
vel_y = get(handles.vely_slider,'Value');
vel_theta = get(handles.veltheta_slider,'Value');

velocity = [vel_x; vel_y; vel_theta];

% delta_pose = handles.velocity;

% var_x = 0.0001;
% var_y = 0.0001;
% var_theta = 0.0001;

var_x = 0;
var_y = 0;
var_theta = 0;

R = [var_x 0 0;
    0 var_y 0;
    0 0 var_theta];

% R = zeros(3);

[pose, map, P] = go_EKF(velocity, pose, map, P, map_local, R);

noisy_velocity = velocity + sqrt(R)*randn(3,1);
handles.true_pose = handles.true_pose + noisy_velocity;

%     odom = update_pose(velocity, pose_est);
% handles.true_pose = handles.true_pose + handles.velocity;
set(handles.truepose_text, 'String', num2str(handles.true_pose'));

cla(handles.est_map);
axes(handles.est_map);
view_linemap(map, pose);

cla(handles.true_map);
axes(handles.true_map);
view_linemap(handles.true_lines, handles.true_pose);

handles.pose = pose;
set(handles.pose_text, 'String', num2str(handles.pose'));

handles.P = P;
handles.map = map;
set(handles.map_text, 'String', num2str([handles.map.polar]));


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function true_map_CreateFcn(hObject, eventdata, handles)
% hObject    handle to true_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate true_map


% --- Executes during object creation, after setting all properties.
function est_map_CreateFcn(hObject, eventdata, handles)
% hObject    handle to est_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate est_map


% --- Executes on slider movement.
function vely_slider_Callback(hObject, eventdata, handles)
% hObject    handle to vely_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

vel_y = get(handles.vely_slider,'Value');
set(handles.vely_text, 'String', num2str(vel_y));

% --- Executes during object creation, after setting all properties.
function vely_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vely_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function velx_slider_Callback(hObject, eventdata, handles)
% hObject    handle to velx_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
vel_x = get(handles.velx_slider,'Value');
set(handles.velx_text, 'String', num2str(vel_x));


% --- Executes during object creation, after setting all properties.
function velx_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to velx_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function veltheta_slider_Callback(hObject, eventdata, handles)
% hObject    handle to veltheta_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
vel_theta = get(handles.veltheta_slider,'Value');
set(handles.veltheta_text, 'String', num2str(vel_theta));


% --- Executes during object creation, after setting all properties.
function veltheta_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to veltheta_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
