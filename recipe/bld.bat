:: MSVC is preferred.
set CC=cl.exe
set CXX=cl.exe

set PKG_CONFIG_PATH="%LIBRARY_BIN%\pkgconfig;%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig;%BUILD_PREFIX%\Library\lib\pkgconfig;%BUILD_PREFIX%\Library\bin\pkgconfig"
set PKG_CONFIG_EXECUTABLE=%LIBRARY_BIN%\pkg-config

copy "%LIBRARY_LIB%\pkgconfig\freeglut.pc" "%LIBRARY_LIB%\pkgconfig\glut.pc"
copy "%LIBRARY_INC%\GL\glut.h" "%LIBRARY_INC%\GL\freeglut.h"

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
    -DGLUT_glut_LIBRARY_RELEASE=%LIBRARY_LIB%\freeglut.lib ^
    -Dpkgcfg_lib_PC_GLUT_glut:FILEPATH="%LIBRARY_LIB%\pkgconfig\glut.pc" ^
    -DCMAKE_FIND_DEBUG_MODE=TRUE ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1
