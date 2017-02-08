{-# LANGUAGE BangPatterns #-}

module Main where

import Control.Monad (unless)
import Network.Socket hiding (recv)
import Network.Socket.ByteString (recv, sendAll)
import Data.Int
import Data.Time
import qualified Data.ByteString as S

main :: IO ()
main = withSocketsDo $ do 
  addrinfos <- getAddrInfo
    (Just (defaultHints {addrFlags = [AI_PASSIVE]}))
    Nothing 
    (Just "8502")
  let serveraddr = head addrinfos
  sock <- socket (addrFamily serveraddr) Stream defaultProtocol
  bind sock (addrAddress serveraddr)
  listen sock 1
  putStrLn "Waiting for connection"
  (conn, _) <- accept sock
  putStrLn "Connection Established"
  start <- getCurrentTime
  totalBytes <- getCount conn 0
  end <- getCurrentTime
  let elapsed = diffUTCTime end start
      bytesPerSecond = fromIntegral totalBytes / fromRational (toRational elapsed) :: Double
  putStrLn ("Total number of bytes received: " ++ show totalBytes)
  putStrLn ("Number of seconds: " ++ show elapsed)
  putStrLn ("Bytes per second: " ++ show (round bytesPerSecond :: Int64))
  putStrLn ("Kibibytes per second: " ++ show (round (bytesPerSecond / 1024) :: Int64))
  close conn
  close sock
  where
  getCount :: Socket -> Int64 -> IO Int64
  getCount !conn !counter = do 
    !msg <- recv conn 1024
    if S.null msg
      then return counter
      else getCount conn (counter + fromIntegral (S.length msg))


