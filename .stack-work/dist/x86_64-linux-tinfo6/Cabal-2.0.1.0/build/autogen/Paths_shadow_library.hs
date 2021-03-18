{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_shadow_library (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/johny/Pulpit/ISI/twilight-library/.stack-work/install/x86_64-linux-tinfo6/81f0510467492864a086a6e475d0acfd845fd2ac3184ffef48be8290f9aa09fb/8.2.2/bin"
libdir     = "/home/johny/Pulpit/ISI/twilight-library/.stack-work/install/x86_64-linux-tinfo6/81f0510467492864a086a6e475d0acfd845fd2ac3184ffef48be8290f9aa09fb/8.2.2/lib/x86_64-linux-ghc-8.2.2/shadow-library-0.1.0.0-5aC4GQbmpkUJXPfTJcpvSC"
dynlibdir  = "/home/johny/Pulpit/ISI/twilight-library/.stack-work/install/x86_64-linux-tinfo6/81f0510467492864a086a6e475d0acfd845fd2ac3184ffef48be8290f9aa09fb/8.2.2/lib/x86_64-linux-ghc-8.2.2"
datadir    = "/home/johny/Pulpit/ISI/twilight-library/.stack-work/install/x86_64-linux-tinfo6/81f0510467492864a086a6e475d0acfd845fd2ac3184ffef48be8290f9aa09fb/8.2.2/share/x86_64-linux-ghc-8.2.2/shadow-library-0.1.0.0"
libexecdir = "/home/johny/Pulpit/ISI/twilight-library/.stack-work/install/x86_64-linux-tinfo6/81f0510467492864a086a6e475d0acfd845fd2ac3184ffef48be8290f9aa09fb/8.2.2/libexec/x86_64-linux-ghc-8.2.2/shadow-library-0.1.0.0"
sysconfdir = "/home/johny/Pulpit/ISI/twilight-library/.stack-work/install/x86_64-linux-tinfo6/81f0510467492864a086a6e475d0acfd845fd2ac3184ffef48be8290f9aa09fb/8.2.2/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "shadow_library_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "shadow_library_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "shadow_library_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "shadow_library_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "shadow_library_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "shadow_library_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
