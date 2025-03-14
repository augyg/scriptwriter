{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import LLM.Types
import LLM.LLM
import Scrappy.Scrape as S
import Text.Parsec as Psc
import Network.HTTP.Client
import Network.HTTP.Client.TLS
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.State
import Data.Aeson as Aeson
import Text.IStr
import Data.Default
import qualified Data.Map as Map
import qualified Data.Text.IO as T
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import qualified Data.ByteString.Lazy as LBS
import GHC.Generics
import Data.Time.Clock
import System.Directory
import Options.Applicative as CLI



main :: IO ()
main = do
  writeFile "/home/lazylambda/time_ran.txt" . show =<< getCurrentTime
  let writer = writeFromScriptPlan DS_70b
  mapM_ writer leCanvas

data ScriptPlan = ScriptPlan
  { _script_title :: T.Text
  , _script_category :: ScriptCategory
  , _script_description :: T.Text
  , _script_outline :: OutlineParams
  , _script_keyFacts :: [T.Text]  -- I wonder if this will be more of a result of AI creation (added pre-step) than manual? 
  , _script_style :: T.Text -- which emotions, whats the balance of storytelling vs stat sharing?
  , _script_remindSection :: T.Text -- important prompt-info that the model should be reminded about during creation of each section
  }


leCanvas :: [ScriptPlan]
leCanvas = [howBadAreTheJets, julioJonesLegend, theBiggestOneSeasonWonder, howBadIsTheProBowlActually, bryceYoung]


completed = [timTebow]

-- | IDEAS --------
-- The intro needs work
  -- the intro is always very essay style whereas it needs to open curiousity gaps instead
  -- and be a little mysterious.
  --
  -- It would be wise to pass in extra instructions for the intro only (like _remindSection ) 


-- |An editor
  -- since we dont want to overwhelm the LLM with what to do so that it loses focus on has too many objectives,
  -- we can literally create an editing step where we scrape for phrases or more generic patterns we would like to avoid.
  -- If the scraper returns N results we should have another pass through with the 'runEditor' function which says
  -- here is the text you gave me, here is my feedback { list out the points } please revise
  --
  -- Requirements
    -- Research: enough phrases to care about this function
    -- Tracking: I need better workflow information in order to impl. any workflow
-- phrases to cut out:
  -- "I will argue that"
  -- titles throughout the text instead of continuous flow



-- An analyzer
data AnalysisPlan = AnalysisPlan
  { _analysis_question :: T.Text -- eg Who is the best Kicker in NFL history?
  , _analysis_rankType :: Ranking -- eg the top 10 best kickers OR the best kicker ever
  }
data Ranking
  = Most -- (best|worst) <somenoun> in NFL <timeframe>
  | TopN Int -- eg the top 10 best kickers
theDirtiestPlayerInNFLHistory = undefined -- lets do this later via ranking ideas
-- | --------



-- | Believe it or not, this has not been done 
samDarnold :: ScriptPlan
samDarnold = ScriptPlan
  { _script_title = "How GOOD is Sam Darnold Actually?"
  , _script_category = HowGood
  , _script_description = mconcat
    [ "Sam Darnold’s career has been a rollercoaster ride since entering the NFL as a highly-touted first-round pick. Once seen as a franchise savior, he has struggled with inconsistency, turnover issues, and less-than-ideal situations. Now in 2024, he’s had another opportunity to prove himself. But has he truly made strides as a quarterback, or are we seeing more of the same? In this deep-dive analysis, we’ll examine Darnold’s performance this season from multiple angles: Statistical Breakdown: We’ll compare his passing efficiency, touchdown-to-interception ratio, completion percentage, and advanced metrics like EPA/play and CPOE to his previous seasons and other quarterbacks in the league. Film Study: Through key game footage, we’ll analyze his pocket presence, decision-making, mechanics, and ability to execute under pressure. Has he shown better field vision, or are old habits still haunting him? Supporting Cast & Playcalling: How much of his success (or struggles) can be attributed to the weapons around him and the offensive system? Is he being put in a position to succeed, or is he still fighting an uphill battle? Comparisons & Future Outlook: Does Darnold have what it takes to secure a long-term starting role, or is he destined to be a high-end backup? We’ll compare his trajectory to other quarterbacks who found late-career success or fizzled out after multiple chances. By the end of this video, you’ll have a clearer picture of whether Sam Darnold has truly turned the corner or if the same issues are still holding him back. Let me know in the comments: is he proving himself, or is it time to move on?"
    ]
  , _script_outline = TotalTime (14 * 60)
  , _script_keyFacts = []
  , _script_remindSection = ""
  , _script_style = "This script should be heavily focused on stats and reason towards whether or not we should expect his great play to continue"
  }

bryceYoung :: ScriptPlan 
bryceYoung = ScriptPlan
  { _script_title = "How a car accident revived an NFL Career"
  , _script_category = Underdog
  , _script_description = mconcat
    -- ChatGPT generated
    [ "Bryce Young's journey with the Carolina Panthers has been a rollercoaster of challenges and triumphs. Selected as the first overall pick in the 2023 NFL Draft, Young faced immense expectations. His rookie season was marred by struggles, culminating in a 2–15 record and personal statistics that fell short of anticipations. The start of the 2024 season didn't offer much respite, as Young was benched after two consecutive losses, during which he failed to throw a touchdown and recorded three interceptions. A pivotal moment occurred in October 2024 when veteran quarterback Andy Dalton was involved in a car accident, resulting in a sprained right thumb. This unforeseen incident thrust Young back into the starting role. Seizing the opportunity, he showcased significant improvement, leading the Panthers to notable victories over teams like the New Orleans Saints and the New York Giants. His performance against the Kansas City Chiefs was particularly commendable, where he completed 21 of 35 passes for 263 yards and a touchdown, narrowly missing a win in a 30–27 loss. From Week 8 onward, Young demonstrated resilience and growth. He completed 61.8% of his passes, amassing 2,104 yards, 15 touchdowns, and six interceptions, along with five rushing touchdowns. This resurgence not only revitalized his career but also instilled renewed hope within the Panthers' organization. Head coach Dave Canales affirmed Young's position as the team's starting quarterback for the upcoming 2025 season, signaling confidence in his continued development. Bryce Young's narrative is a testament to perseverance in the face of adversity. His ability to rebound from early setbacks and capitalize on unforeseen opportunities underscores his potential and determination to succeed at the highest level."
    ]
  , _script_outline = TotalTime (14 * 60)
  , _script_keyFacts =
    [ "First Overall Pick (2023 NFL Draft): The Carolina Panthers selected Bryce Young as the #1 overall pick out of Alabama."
    , "Rookie Year (2023 Season): Struggled significantly, finishing the season with a 2–15 record as a starter."
    , "Poor Statistics: Recorded 11 touchdowns, 10 interceptions, and only 2,877 passing yards, struggling behind a weak offensive line."
    , "Benching in 2024: Started the 2024 season poorly, getting benched after two straight losses, completing less than 60% of his passes."
    , "Andy Dalton’s Car Crash (October 2024): Veteran backup Andy Dalton suffered a sprained right thumb in a car accident, forcing Young back into the starting lineup."
    , "Breakout Performance: Led the Panthers to back-to-back wins over the Saints and Giants, marking a noticeable improvement in decision-making and confidence."
    , "Near Upset vs. Chiefs: Played a strong game against Patrick Mahomes and the Chiefs, throwing for 263 yards and a touchdown in a close 30-27 loss."
    , "Stats After Return (Weeks 8-18, 2024):61.8% completion rate 2,104 passing yards 15 touchdowns, 6 interceptions 5 rushing touchdowns"
    , "Panthers’ head coach Dave Canales confirmed Young as the starting QB moving forward."
    , "Improved Leadership & Confidence: Reported to be more vocal in the locker room and showing better command of the offense."
    , "New Offensive System: The Panthers plan to build around Young, improving the offensive line and receiving corps to support his development."
    ]
  , _script_remindSection = ""
  , _script_style = "The script should be inspiring and also heavily stats-based."
  }


-- https://www.pro-football-reference.com/players/S/SipeBr00.htm
-- 
-- Brian Sipe was a 13th-round draft pick, made 0 Pro Bowls before the age of 31, won an MVP at 31, and was out of the league by 34, earning zero accolades after his MVP season.
--
-- Maybe it's a bit unfair to call him a one year wonder since he was a starting QB in the NFL for 6 years, but I have to think he's the only MVP-winning QB with 1 Pro Bowl selection.
theBiggestOneSeasonWonder :: ScriptPlan
theBiggestOneSeasonWonder = ScriptPlan
  { _script_title = "Meet the NFL's All-Time One Season Wonder"
  , _script_category = OneHitWonder
  , _script_description = mconcat
    [ " This script will argue that Brian Sipe is the biggest one hit wonder of NFL history "
    , "Brian Sipe was a 13th-round draft pick, made 0 Pro Bowls before the age of 31, won an MVP at 31, and was out of the league by 34, earning zero accolades after his MVP season."
    , " Maybe it's a bit unfair to call him a one year wonder since he was a starting QB in the NFL for 6 years, but I have to think he's the only MVP-winning QB with 1 Pro Bowl selection."
    , " This video should blatantly call out the common idea that Peyton Hillis is the biggest one season wonder and say that this is "
    , " only believed because he was on the Madden cover, not to mention injuries. However Brian Sipe was truly the biggest season wonder"
    , " based on comparative analytics and stats + awards. I would consider leading the arg that he's a bigger one season wonder with the "
    , " fact he won MVP once and never made pro bowl outside that season"
    ]
  , _script_outline = TotalTime (14 * 60)
  , _script_keyFacts = [ "Sipe enrolled at San Diego state in 1968, 2 years before they were a Division 1 school" ]
  , _script_remindSection = ensureFactBased 
  , _script_style = "Despite this being a story about a one-hit wonder, viewers should feel inspired by his eventual rise to MVP status"
  }

ensureFactBased :: T.Text
ensureFactBased = "Also my audience loves tidbits of football analysis and facts.\
  \ Please use these to back up any claims about a play or game or player’s ability. For example\
  \ if I say it was a great game. It would be better to say this was the first game all season\
  \ where the number 1 and number 2 ranked teams were facing off. Ensure that every single fact and stat\
  \ that is used is verifiably true"

howBadIsTheProBowlActually :: ScriptPlan
howBadIsTheProBowlActually = ScriptPlan
  { _script_title = "How BAD is the Pro-Bowl Actually?"
  , _script_category = HowBad
  , _script_description = mconcat
    [ " The pro bowl has gone from huge hits to being passed up by the first 10 selected players so that you have the 21st out of 30 ranked "
    , " players at a position, playing stupid crap games. Viewership has dropped off. Compare how entertaining the Pro Bowl was 10 years ago "
    , " vs now."
    ]
  , _script_outline = TotalTime (14 * 60)
  , _script_keyFacts = []
  , _script_remindSection = ""
  , _script_style = mconcat
    [ "This script should be both fact based and quite humourous about how silly the pro-bowl has become. It should be a facts"
    , " based roast of the modern Pro bowl"
    ]
  }


julioJonesLegend :: ScriptPlan
julioJonesLegend = ScriptPlan
  { _script_title = "How GOOD was Julio Jones Actually?"
  , _script_category = HowGood
  , _script_description = mconcat
    -- AI generated
    [ "Julio Jones isn’t just a wide receiver—he’s a game-changer. From his explosive speed to his insane catch radius, few have ever dominated the field like he did. In this video, we break down his legendary career, highlight his best plays, and analyze what made him such a nightmare for defenses.From his days at Alabama to his record-breaking performances with the Atlanta Falcons, we’ll cover it all. Was he the most physically gifted receiver of his era? Did injuries keep him from an even greater legacy? Let’s dive deep into the numbers, film, and impact of one of the NFL’s most unstoppable forces."
    ]
  , _script_outline = TotalTime (14 * 60)
  , _script_remindSection = ""
  , _script_keyFacts = []
  , _script_style = "Viewers should feel inspired and it should also be very fact and stat driven" 
  }

howBadAreTheJets :: ScriptPlan
howBadAreTheJets = ScriptPlan
  { _script_title = "How BAD are the New York Jets Actually?"
  , _script_category = HowBad
  , _script_description = mconcat
    [ "How the Jets are coming off a horrible season firing a well liked coach (Robert Saleh) "
    , " despite players like Sauce Gardner publicly criticizing the decision, and also how despite "
    , " Aaron Rodgers finally being available to play, and a star studded cast around the season was "
    , " another massive flop. The owner Woody Johnson is also definitely a big part of the problem. "
    , " According to https://www.si.com/nfl/jets/news/jets-owner-woody-johnson-cited-madden-ratings-evaluating-players "
    , " he decided against acquiring Jerry Jeudy due to a poor madden awareness rating which is hilariously stupid."
    , " Additionally, there are many former Jets players who have left the team and become amazing late bloomers like"
    , " Sam Darnold with 14 wins this year, and Geno Smith having a couple career years with the Seahawks"
    ]
  , _script_outline = TotalTime (14 * 60)
  , _script_keyFacts = []
  , _script_style = "This should be a deeply stats-based script and also full of humour laughing about how bad the Jets are"
  , _script_remindSection = ""
  }

timTebow :: ScriptPlan 
timTebow = ScriptPlan
  { _script_title = "How GOOD was Tim Tebow?"
  , _script_category = HowGood
  , _script_description = "how Tim Tebow had a legendary college career as well as a controversial NFL career with lots of highs and lows."
  , _script_outline = TotalTime (12 * 60)
  , _script_keyFacts = []
  , _script_style = "Viewers should feel inspired"
  , _script_remindSection = ""
  }

channelGenericInstructions :: T.Text
channelGenericInstructions =
  "the voiceover / script will be continuous throughout the video so there will be no pauses for\
  \ clips. Please factor this in. Also my audience loves tidbits of football analysis and facts.\
  \ Please use these to back up any claims about a play or game or player’s ability. For example\
  \ if I say it was a great game. It would be better to say this was the first game all season\
  \ where the number 1 and number 2 ranked teams were facing off. Another example is that Tebow\
  \ is a left handed QB which is rare so if it had been 10 years since a left handed QB had won\
  \ a playoff game (or achieved any other significant stat) it is probably worth mentioning in\
  \ order to bolster the claim and gain the audiences trust. Trust with the audience is by far\
  \ the most important thing because our viewers are highly knowledgeable and love learning\
  \ things about football that they never knew "
  <> "for more in-depth information on the audience, the following is a psychographic analysis on the audience"
  <> "\n" <> psychographic <> "\n"


psychographic :: T.Text
psychographic = T.pack $ [istr|
FOOTBALL NICHE VIDEO IDEAS

**Psychographic Questions**
- What sort of language do they connect with
    - simple
    - common sporting terms peak their respect for the speaker
    - analytical and comparative when talking sports
- What stage of their journey are they at? (beginner vs expert)
    - quite a range but likely to be at least "almost medium" level
    - More likely to be expert than a beginner if they are watching  a YT video
- Are they here to learn or to be entertained
    - to be entertained
    - small bit of learning (to apply to Fantasy) but not here for it
- What TV/media do they watch?
    - All kinds of sports 
    - Sundays are for football
    - likely a 2nd sport (in order of probability)
        - MMA 
        - Baseball
        - Hockey
        - Basketball
        - Rugby
        - Soccer
    - Probably Right-leaning media
- What are their hobbies
    - Beer leagues
    - Video Games
- Whats their ultimate goal
    - be entertained and be a football guru
|]

categoryMap :: Map.Map ScriptCategory T.Text
categoryMap = Map.fromList
  [ (MEAN, "")
  , (RiseAndFall,"")
  , (Underdog, "")
  , (Emotional, "")
  , (HowBad, mconcat
      [ "This video will focus on a team or organization that has been disastrously bad. You should discuss the downfalls they have faced."
      , " If there are stats to suggest that they have also shown glimmers of hope then you should argue back and forth both sides"
      ]
    )
  , (HowGood,"This video will focus on how good a player was. Meaning the script should provide a chronological overview of times they have done horribly and times they have been great.")
  , (StatisticalClub, "")
  , (IsBestOfAllTime,"")
  , (IsWorstOfAllTime,"")
  , (OneHitWonder, "This video will focus on a player who for some reason had one amazing season but was statistically brutal for the rest of their career")
  ]






data CLIOptions = CLIOptions
  { ds_model :: DeepSeekModel
  }



data OutlineParams
  = TotalTime Seconds
  | TimedSection [(SectionName, SectionLength)]
  | MandatorySections [SectionName]
  
type SectionName = T.Text
type Seconds = Int 
type SectionLength = Seconds

data ScriptCategory
  = MEAN
  | RiseAndFall
  | Underdog
  | Emotional
  | HowBad
  | HowGood
  | StatisticalClub
  | IsBestOfAllTime
  | IsWorstOfAllTime
  | OneHitWonder
  deriving (Eq,Ord)

data ScriptSectionPlan = ScriptSectionPlan
  { _sectionPlan_title :: T.Text
  , _sectionPlan_wordCount :: Int
  , _sectionPlan_numberOfSeconds :: Int
  , _sectionPlan_outline :: T.Text 
  } deriving (Show,Generic)

data ScriptSectionComplete = ScriptSectionComplete
  { _section_title :: T.Text
  , _section_wordCount :: Int
  , _section_numberOfSeconds :: Int
  , _section_text :: T.Text 
  } deriving (Show,Generic) 

instance Default ScriptSectionPlan where
  def = ScriptSectionPlan
    { _sectionPlan_title = ""
    , _sectionPlan_wordCount = 0
    , _sectionPlan_numberOfSeconds = 0
    , _sectionPlan_outline = ""
    }

instance ToJSON ScriptSectionPlan
instance FromJSON ScriptSectionPlan
instance ToJSON ScriptSectionComplete 
instance FromJSON ScriptSectionComplete


deepSeekModelChoice :: ReadM DeepSeekModel
deepSeekModelChoice = eitherReader $ \arg -> case arg of
  "DS_1_5b" -> Right DS_1_5b
  "DS_7b" -> Right DS_7b
  "DS_8b" -> Right DS_8b
  "DS_14b" -> Right DS_14b
  "DS_32b" -> Right DS_32b
  "DS_70b" -> Right DS_70b
  "DS_671b" -> Right DS_671b
  _          -> Left "Valid operations: add, subtract"


  
optionsParser :: Parser CLIOptions
optionsParser = CLIOptions
  <$> CLI.option deepSeekModelChoice
      ( long "model"
     <> metavar "model"
     <> help "model select" )

-- main :: IO ()
-- main = do
--   opts <- execParser optsInfo
--   writeFromScriptPlan (ds_model opts) myScript 
--   --mapM_ putStrLn (replicate (repeatCount opts) ("Hello, " ++ name opts))
--   pure () 
--   where
--     optsInfo = info (optionsParser <**> helper)
--       ( fullDesc
--         <> progDesc "A simple greeting CLI"
--         <> header "Haskell CLI Example" )





getScriptSectionText :: DeepSeekAnswer -> Either Psc.ParseError T.Text
getScriptSectionText = fmap (mconcat . _thoughtResponse_answer ) . toThoughtResponse . \(GPTAnswer x) -> x

renderSection :: ScriptSectionPlan -> T.Text
renderSection sect = mconcat
  [ _sectionPlan_title sect
  , " ensure a word count of "
  , tshow $ _sectionPlan_wordCount sect
  , "!"
  , " based on the summary/overview: "
  , _sectionPlan_outline sect
  , "While your task is just to write this section, make sure that it flows well from section to section as this is a continuous script"
  ] 


data GetSectionError = NoCodeBlock | WrongCodeBlock | NoThoughtResponse | FailedAesonParse
getSections :: DeepSeekAnswer -> Either String [ScriptSectionPlan] 
getSections (GPTAnswer cwr_) =
  let
    thoughtRes = toThoughtResponse cwr_
    -- getAnswerAsString = T.unpack . mconcat . _thoughtResponse_answer
  in
    case thoughtRes of
      Left parseError -> Left $ "Couldn't create ThoughtResponse: " <> show parseError
      Right _thRes ->
        let mCodeBlock = S.scrapeFirst' codeBlock $ T.unpack $ _cwr_content cwr_ --  $ getAnswerAsString thRes
        in case mCodeBlock of
          Nothing -> Left "No code block found"
          Just (codeType, cblock) -> 
            case codeType of
              "json" -> 
                case (eitherDecode (LBS.fromStrict . T.encodeUtf8 . T.pack $ cblock)) of
                  -- the most likely case for error here is a comment in the JSON codeblock
                  Left e -> Left $  "Failed at JSON parser step: " <> show e
                  Right (plan :: [ScriptSectionPlan]) -> Right plan 
              _ -> Left $ "received different type of codeblock: " <> codeType




  
runStateAction :: MonadIO m => Manager -> DeepSeekModel -> [ContentWithRole] -> MonadDeepSeek m (Either GPTError DeepSeekAnswer)
runStateAction mgr modelChoice cwrs = do
  askDeepSeekWithContext mgr modelChoice (LastN_DS 1000) (TagDS "sometag" False, DeepSeekQuestion cwrs) >>= \case
    Left e -> do
      liftIO $ print e
      runStateAction mgr (pred modelChoice) cwrs
    Right x -> pure $ Right x
  

-- | An example case would be "who are the 10 biggest busts in NFL history? rank by params: {...}"
createScriptPlan :: T.Text -> IO ScriptPlan
createScriptPlan _title = undefined


writeFromScriptPlan :: DeepSeekModel -> ScriptPlan -> IO ()
writeFromScriptPlan modelChoice plan = do 
  writeScript
    modelChoice
    (_script_title plan)
    catDesc
    (_script_description plan)
    outlineInst
    keyFacts
    (_script_style plan)
    (_script_remindSection plan)
  where
    catDesc = categoryMap Map.! (_script_category plan)
    outlineInst = renderOutlineInstructions (_script_outline plan) 
    keyFacts = renderKeyFacts (_script_keyFacts plan)

renderKeyFacts :: [T.Text] -> T.Text
renderKeyFacts = T.intercalate "\n" . fmap ("-" <>) 
    
renderOutlineInstructions :: OutlineParams -> T.Text
renderOutlineInstructions = \case
  TotalTime s -> "ensure that the total time of the video is " <> (tshow s) <> " seconds."
  TimedSection sects -> "ensure that the following sections are included: " <> (T.intercalate "," $ renderSect <$> sects) <> "."
  MandatorySections sects -> "ensure that you include the following sections " <> (T.intercalate ", " sects) <> "."  
  where
    renderSect (n,l) = n <> " for roughly " <> (tshow l) <> " seconds"   
    
writeScript :: DeepSeekModel -> T.Text -> T.Text -> T.Text -> T.Text -> T.Text -> T.Text -> T.Text -> IO () 
writeScript modelChoice title categoryInstructions vidDesc outlineInstructions keyFacts scriptStyle sectionReminders = do
  mgr <- newManager tlsManagerSettings
  --script <- readFile "damar.txt" 
  (eithScript :: Either () [ScriptSectionComplete], _finalState) <- flip runStateT [] $ do
    dsAnswer <- runStateAction mgr modelChoice 
      [ cwr User $ mconcat
        [ "can you please write me a youtube voiceover script for the title: "
        , title
        , "the video description is "
        , vidDesc <> scriptStyle         
        , "for this kind of video please note: "
        , categoryInstructions
        , " also "
        , channelGenericInstructions
        , "\n"
        , ( if keyFacts /= ""
            then "for this video and content choices you make, keep in mind the following key facts: " <> keyFacts
            else ""
          ) 
        , "this will be a multi-step process, so let's start with an overview of the script."
        , " for the overview you craft please ", outlineInstructions
        , "The speaker of this script will average 215 words per minute."
        , " The first step will be creating an overview of what the script should be. In your response, as an array of the following \
          \JSON structure. For each element of the JSON array representing a section, follow this structure exactly: "
        , T.decodeUtf8 $ LBS.toStrict $ Aeson.encode (def :: ScriptSectionPlan)
        ]
      ]
    liftIO $ putStrLn "got dsAnswer"
    case dsAnswer of
      Left e -> do
        liftIO $ print e
        liftIO $ putStrLn "Failed get overview"
        pure $ Left ()
      Right dsAnswer' -> do 
        -- use code block scraper + decode block with Aeson.decode
        let sections' = getSections dsAnswer'
        case sections' of
          Left e -> do
            liftIO $ putStrLn e
            liftIO $ Aeson.encodeFile "getSectionsFailure.json" dsAnswer'
            pure $ Left ()
          Right sections -> do
            let numTODO = length sections 
            x :: [Either () ScriptSectionComplete] <- forM (zip [1 :: Int ..] sections) $ \(sectNum, section) -> do
              liftIO $ do
                putStrLn $ "Working on section " <> (show sectNum) <> "/" <> (show numTODO)
                putStrLn $ "SectionTitle: (" <> (show $ _sectionPlan_wordCount section) <> "): " <> (T.unpack $ _sectionPlan_title section) 
              dsSectionAnswer <- runStateAction mgr modelChoice
                [ cwr User $ mconcat
                  [ "Now Write: "
                  , renderSection section
                  , sectionReminders
                  ]
                ]
              case dsSectionAnswer of
                Left _ -> do
                  liftIO $ print $ "Failed get section for " <> show section
                  pure $ Left ()
                Right dsSectionAnswer' -> do
                  case getScriptSectionText dsSectionAnswer' of
                    Left e -> do
                      liftIO $ putStrLn $ "Failed get section text via thoughtResponse answer" <> show e
                      pure $ Left ()
                    Right scriptSectionText -> do 
                      pure $ Right $ ScriptSectionComplete
                        (_sectionPlan_title section)
                        (_sectionPlan_numberOfSeconds section)
                        (_sectionPlan_wordCount section)
                        scriptSectionText 
            pure $ sequenceA x

  Aeson.encodeFile "/home/lazylambda/Documents/GridironGreats/scripts/history.json" (_finalState)
  case eithScript of
    Left _ -> putStrLn "error happened" 
    Right (script :: [ScriptSectionComplete]) -> do
      Aeson.encodeFile "/home/lazylambda/Documents/GridironGreats/scripts/script.json" script
      writeNextAvailableFile ("/home/lazylambda/Documents/GridironGreats/scripts/" <> T.unpack title) ".txt" $ renderScript script 
  pure ()

renderScript :: [ScriptSectionComplete] -> T.Text
renderScript = T.intercalate "\n" . fmap renderScriptSectionComplete  

renderScriptSectionComplete :: ScriptSectionComplete -> T.Text
renderScriptSectionComplete s = T.intercalate "\n"
  [ "###" <> (_section_title s)
  , "####" <> (tshow $ _section_wordCount s) <> "words |" <> (tshow $ _section_numberOfSeconds s) <> " seconds"
  , _section_text s 
  ]
  

findNextAvailableFile :: FilePath -> String -> IO FilePath
findNextAvailableFile base ext = go 1
  where
    go :: Int -> IO FilePath
    go n = do
      let candidate = base ++ "-" ++ show n ++ ext
      doesFileExist candidate >>= \case
        True -> go (n+1)
        False -> return candidate
      -- exists_ <- doesFileExist candidate
      -- if exists_
      --   then go (n + 1)
      --   else return candidate

writeNextAvailableFile :: FilePath -> String -> T.Text -> IO ()
writeNextAvailableFile base ext str = do
  fp <- findNextAvailableFile base ext
  T.writeFile fp str

