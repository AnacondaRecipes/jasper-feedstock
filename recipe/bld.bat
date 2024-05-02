:: MSVC is preferred.
set CC=cl.exe
set CXX=cl.exe

REM The pkg-config path and executable are needed to find the freeglut header and library
set PKG_CONFIG_PATH="%LIBRARY_BIN%\pkgconfig;%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig;%BUILD_PREFIX%\Library\lib\pkgconfig;%BUILD_PREFIX%\Library\bin\pkgconfig"
set PKG_CONFIG_EXECUTABLE=%LIBRARY_BIN%\pkg-config

REM The default %LIBRARY_LIB%\freeglut.lib can't be found by CMake even ig GLUT_glut_LIBRARY_RELEASE is defined.
REM While linking C executable src\app\jiv.exe two files are required glut.lib AND(!) freeglutd.lib instead of freeglut.lib. 
REM So we rename freeglut.lib to glut.lib and freeglutd.lib.
REM At the same time pkg-config is looking for glut.pc but not freeglut.pc. Renaming it fixes the issue.
copy %LIBRARY_LIB%\pkgconfig\freeglut.pc %LIBRARY_LIB%\pkgconfig\glut.pc
copy %LIBRARY_LIB%\freeglut.lib %LIBRARY_LIB%\glut.lib
copy %LIBRARY_LIB%\freeglut.lib %LIBRARY_LIB%\freeglutd.lib

mkdir build_src
cd build_src

cmake -LAH ^
    -G "Ninja" ^
    %CMAKE_ARGS% ^
    -DALLOW_IN_SOURCE_BUILD=ON ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DBUILD_SHARED_LIBS=ON ^
    -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=ON ^
    -DJAS_ENABLE_LIBHEIF=OFF ^
    -DJAS_ENABLE_DOC=OFF ^
    -DJPEG_LIBRARY_RELEASE=%LIBRARY_LIB%\libjpeg.lib ^
    -DGLUT_INCLUDE_DIR:PATH=%LIBRARY_INC% ^
    -DGLUT_glut_LIBRARY_RELEASE=%LIBRARY_LIB%\glut.lib ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1

ctest --output-on-failure
if errorlevel 1 exit 1
