@echo ON

:: MSVC is preferred.
set CC=cl.exe
set CXX=cl.exe

REM The pkg-config path and executable are needed to find the freeglut header and library
set PKG_CONFIG_PATH="%LIBRARY_BIN%\pkgconfig;%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig;%BUILD_PREFIX%\Library\lib\pkgconfig;%BUILD_PREFIX%\Library\bin\pkgconfig"
set PKG_CONFIG_EXECUTABLE=%LIBRARY_BIN%\pkg-config

mkdir build_src
cd build_src

cmake -G "Ninja" -B build_shared -S %SRC_DIR% ^
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
    -DGLUT_glut_LIBRARY_RELEASE=%LIBRARY_LIB%\glut.lib
if errorlevel 1 exit 1

:: Build.
cmake --build build_shared --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build build_shared --config Release --target install
if errorlevel 1 exit 1
