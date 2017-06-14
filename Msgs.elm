module Msgs exposing (..)
import Http exposing (..)
import RemoteData exposing (WebData)
import Models exposing (..)
import Navigation exposing (Location)
import SignIn.Types exposing (UserAuth)
import Registration.Types exposing (..)

type Msg = SignInMsg SignIn.Types.Msg |
           RegistrationMsg Registration.Types.Msg |
           OnUserAuth UserAuth |
           RemoveProject Project |
           RemoveChecklist Checklist |
           RemoveItem Item |

           GotoProject |

           ToggleItemCompleted Item |
           UpdatedItem (Result Http.Error String) |

           EditItem String |
           EditingItem Item |
           OnEditItemInput String |

           SelectProject Project |
           SelectChecklist Checklist |

           OnSaveProject (Result Http.Error Int) |
           OnSaveChecklist (Result Http.Error Int) |
           OnSaveItem (Result Http.Error Int) |

           DeleteProject (Result Http.Error String) |
           DeletedChecklist (Result Http.Error String) |
           DeletedItem (Result Http.Error String) |

           OnNewProjectKeyDown Int |
           OnNewProjectInput String |

           OnNewChecklistKeyDown Int |
           OnNewChecklistInput String |

           OnNewItemKeyDown Int |
           OnNewItemInput String |

           GetProjects |
           OnLocationChange Location |

           OnFetchProjects (WebData (List Project)) |
           OnFetchProjectChecklists (WebData (List Checklist)) |
           OnFetchChecklistItems (WebData (List Item))
