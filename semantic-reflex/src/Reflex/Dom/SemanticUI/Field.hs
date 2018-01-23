{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}

-- | Semantic UI fields.
-- https://semantic-ui.com/collections/form.html
module Reflex.Dom.SemanticUI.Field
  (

  -- * Field
    field, field'
  , FieldConfig (..)
  , fieldError
  , fieldElConfig

  ) where

import Control.Lens (makeLenses)
import Data.Default
import Data.Semigroup ((<>))
import Reflex
import Reflex.Dom.Core

import Reflex.Dom.Active
import Reflex.Dom.SemanticUI.Common
import Reflex.Dom.SemanticUI.Transition

data FieldConfig t = FieldConfig
  { _fieldError :: Active t Bool
  , _fieldElConfig :: ActiveElConfig t
  }
makeLenses ''FieldConfig

instance HasElConfig t (FieldConfig t) where
  elConfig = fieldElConfig

instance Reflex t => Default (FieldConfig t) where
  def = FieldConfig
    { _fieldError = pure False
    , _fieldElConfig = def
    }

-- | Make the field div classes from the configuration
fieldConfigClasses :: Reflex t => FieldConfig t -> Active t Classes
fieldConfigClasses FieldConfig {..} = activeClasses
  [ Static $ Just "ui field"
  , boolClass "error" _fieldError
  ]

-- | Field UI Element.
field' :: MonadWidget t m => FieldConfig t -> m a -> m (El t, a)
field' config@FieldConfig {..} content
  = uiElement' "div" elConf content
  where
    elConf = _fieldElConfig <> def
      { _classes = fieldConfigClasses config }

-- | Field UI Element.
field :: MonadWidget t m => FieldConfig t -> m a -> m a
field config = fmap snd . field' config
