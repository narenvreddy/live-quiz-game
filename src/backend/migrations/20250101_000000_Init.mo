import Map "mo:core/Map";
import Runtime "mo:core/Runtime";
import List "mo:core/List";
import Time "mo:core/Time";
import Nat "mo:core/Nat";
import Int "mo:core/Int";
import Char "mo:core/Char";
import Storage "mo:caffeineai-object-storage/Storage";
import AccessControl "mo:caffeineai-authorization/access-control";

// Generated initial migration: seeds all stable actor state on a fresh
// install. Actor type definitions are inlined so this frozen chain entry
// does not drift if the actor's types change in a later version.
module {
  type Profile = {
    name : Text;
  };

  type PointMode = {
    #standard;
    #double;
    #none;
  };

  type QuestionType = {
    #quiz;
    #trueFalse;
    #typeAnswer;
    #slider;
  };

  type ImagePlacement = {
    #centered;
    #background;
  };

  type Question = {
    questionType : QuestionType;
    text : Text;
    options : [Text];
    correctOptionIndices : [Nat];
    timeLimit : Nat;
    pointMode : PointMode;
    isMultiSelect : Bool;
    acceptedAnswers : [Text];
    sliderMin : Nat;
    sliderMax : Nat;
    sliderCorrect : Nat;
    image : ?Storage.ExternalBlob;
    imagePlacement : ImagePlacement;
    theme : Text;
    showQuestionToPlayers : Bool;
  };

  type Quiz = {
    id : Nat;
    title : Text;
    questions : [Question];
    createdAt : Int;
    updatedAt : Int;
  };

  type SessionStatus = {
    #lobby;
    #active;
    #ended;
  };

  type GamePhase = {
    #lobby;
    #questionDisplay;
    #answering;
    #results;
    #scoreboard;
    #podium;
    #ended;
  };

  type AnswerSubmission = {
    #options : [Nat];
    #text : Text;
    #slider : Nat;
  };

  type PlayerAnswer = {
    selectedOptions : [Nat];
    textAnswer : Text;
    sliderValue : Nat;
    submittedAt : Int;
    isCorrect : Bool;
    pointsEarned : Nat;
  };

  type PlayerData = {
    token : Nat;
    playerId : Nat;
    displayName : Text;
    avatarIndex : Nat;
    score : Nat;
    currentStreak : Nat;
    answers : Map.Map<Nat, PlayerAnswer>;
    joinedAt : Int;
  };

  type Session = {
    id : Nat;
    quizId : Nat;
    hostPrincipal : Principal;
    roomPin : Text;
    status : SessionStatus;
    players : Map.Map<Nat, PlayerData>;
    isLocked : Bool;
    autoAdvance : Bool;
    currentQuestionIndex : Nat;
    currentPhase : GamePhase;
    phaseStartTime : Int;
    questions : [Question];
    lastHostHeartbeat : Int;
    nextPlayerId : Nat;
  };

  type JoinResult = {
    playerToken : Nat;
    playerId : Nat;
    sessionId : Nat;
    avatarIndex : Nat;
  };

  type SessionInfo = {
    sessionId : Nat;
    roomPin : Text;
  };

  type PublicPlayerData = {
    playerId : Nat;
    displayName : Text;
    avatarIndex : Nat;
    score : Nat;
  };

  type HostQuestionData = {
    questionType : QuestionType;
    text : Text;
    options : [Text];
    correctOptionIndices : [Nat];
    timeLimit : Nat;
    pointMode : PointMode;
    acceptedAnswers : [Text];
    sliderMin : Nat;
    sliderMax : Nat;
    sliderCorrect : Nat;
    image : ?Storage.ExternalBlob;
    imagePlacement : ImagePlacement;
    theme : Text;
    showQuestionToPlayers : Bool;
  };

  type PlayerQuestionData = {
    questionType : QuestionType;
    text : Text;
    options : [Text];
    timeLimit : Nat;
    sliderMin : Nat;
    sliderMax : Nat;
    image : ?Storage.ExternalBlob;
    imagePlacement : ImagePlacement;
    theme : Text;
    showQuestionToPlayers : Bool;
  };

  type SessionStateResponse = {
    sessionId : Nat;
    roomPin : Text;
    status : SessionStatus;
    currentPhase : GamePhase;
    currentQuestionIndex : Nat;
    isLocked : Bool;
    autoAdvance : Bool;
    playerCount : Nat;
    players : [PublicPlayerData];
    phaseStartTime : Int;
    questionCount : Nat;
    currentQuestion : ?HostQuestionData;
    answerCount : Nat;
  };

  type PlayerStateResponse = {
    status : SessionStatus;
    currentPhase : GamePhase;
    isLocked : Bool;
    players : [PublicPlayerData];
    playerCount : Nat;
    ownDisplayName : Text;
    ownAvatarIndex : Nat;
    ownScore : Nat;
    currentQuestionIndex : Nat;
    currentQuestion : ?PlayerQuestionData;
    phaseStartTime : Int;
    hasAnsweredCurrent : Bool;
    lastAnswerCorrect : ?Bool;
    lastPointsEarned : Nat;
    currentStreak : Nat;
    lastHostHeartbeat : Int;
  };

  type AnswerDistribution = {
    optionIndex : Nat;
    count : Nat;
    isCorrect : Bool;
  };

  type QuestionResultsResponse = {
    questionType : QuestionType;
    questionIndex : Nat;
    questionText : Text;
    options : [Text];
    answerDistribution : [AnswerDistribution];
    totalAnswers : Nat;
    correctCount : Nat;
  };

  type LeaderboardEntry = {
    playerId : Nat;
    displayName : Text;
    avatarIndex : Nat;
    score : Nat;
    rank : Nat;
    currentStreak : Nat;
  };

  type LeaderboardResponse = {
    entries : [LeaderboardEntry];
    totalPlayers : Nat;
  };

  type StreakEntry = {
    displayName : Text;
    avatarIndex : Nat;
    streak : Nat;
  };

  type QuestionSummary = {
    questionType : QuestionType;
    questionIndex : Nat;
    questionText : Text;
    options : [Text];
    answerDistribution : [AnswerDistribution];
    totalAnswers : Nat;
    correctCount : Nat;
    correctPercent : Nat;
  };

  type PostGameSummaryResponse = {
    questionSummaries : [QuestionSummary];
    totalPlayers : Nat;
    totalQuestions : Nat;
  };

  type ArchivedPlayerAnswer = {
    questionIndex : Nat;
    selectedOptions : [Nat];
    textAnswer : Text;
    sliderValue : Nat;
    isCorrect : Bool;
    pointsEarned : Nat;
  };

  type ArchivedPlayer = {
    displayName : Text;
    avatarIndex : Nat;
    score : Nat;
    rank : Nat;
    answers : [ArchivedPlayerAnswer];
  };

  type ArchivedQuestion = {
    questionType : QuestionType;
    text : Text;
    options : [Text];
    correctOptionIndices : [Nat];
    acceptedAnswers : [Text];
    sliderMin : Nat;
    sliderMax : Nat;
    sliderCorrect : Nat;
  };

  type ReportSummary = {
    id : Nat;
    quizTitle : Text;
    playedAt : Int;
    playerCount : Nat;
    questionCount : Nat;
  };

  type Report = {
    id : Nat;
    quizTitle : Text;
    playedAt : Int;
    playerCount : Nat;
    questionCount : Nat;
    questions : [ArchivedQuestion];
    players : [ArchivedPlayer];
    summary : PostGameSummaryResponse;
  };

  public func migration(_ : {}) : {
    accessControlState : AccessControl.AccessControlState;
    userProfiles : Map.Map<Principal, Profile>;
    userQuizzes : Map.Map<Principal, Map.Map<Nat, Quiz>>;
    var nextQuizId : Nat;
    sessions : Map.Map<Nat, Session>;
    roomPinIndex : Map.Map<Text, Nat>;
    var nextSessionId : Nat;
    var randomSeed : Nat;
    userReports : Map.Map<Principal, Map.Map<Nat, Report>>;
    var nextReportId : Nat;
    lastJoinTime : Map.Map<Nat, Int>;
  } {
    {
      accessControlState = AccessControl.initState();
      userProfiles = Map.empty();
      userQuizzes = Map.empty();
      var nextQuizId = 0;
      sessions = Map.empty();
      roomPinIndex = Map.empty();
      var nextSessionId = 0;
      var randomSeed = 0;
      userReports = Map.empty();
      var nextReportId = 0;
      lastJoinTime = Map.empty();
    };
  };
};
