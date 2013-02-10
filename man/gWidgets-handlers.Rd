\name{addHandlerChanged.GExpandGroup}
\alias{addHandlerBlur.GCombobox}
\alias{addHandlerBlur.GEdit}
\alias{addHandlerBlur.GText}
\alias{addHandlerBlur.default}
\alias{addHandlerChange.GCheckboxGroup}
\alias{addHandlerChange.GCombobox}
\alias{addHandlerChange.GRadio}
\alias{addHandlerChange.GSequenceSelect}
\alias{addHandlerChange.GSlider}
\alias{addHandlerChange.default}
\alias{addHandlerChanged.GAction}
\alias{addHandlerChanged.GCalendar}
\alias{addHandlerChanged.GCombobox}
\alias{addHandlerChanged.GEdit}
\alias{addHandlerChanged.GExpandGroup}
\alias{addHandlerChanged.GFile}
\alias{addHandlerChanged.GNotebook}
\alias{addHandlerChanged.GPanel}
\alias{addHandlerChanged.GRadio}
\alias{addHandlerChanged.GSequenceSelect}
\alias{addHandlerChanged.GTable}
\alias{addHandlerChanged.GText}
\alias{addHandlerChanged.default}
\alias{addHandlerClicked.GCanvas}
\alias{addHandlerClicked.GRadio}
\alias{addHandlerClicked.GTable}
\alias{addHandlerClicked.default}
\alias{addHandlerDoubleclick.GTable}
\alias{addHandlerDoubleclick.default}
\alias{addHandlerEnter.GEdit}
\alias{addHandlerEnter.default}
\alias{addHandlerMouseDown.GCanvas}
\alias{addHandlerMouseDown.default}
\alias{addHandlerMouseUp.GCanvas}
\alias{addHandlerMouseUp.default}
\alias{addHandlerSelect.GCombobox}
\alias{addHandlerSelect.GTable}
\alias{addHandlerSelect.default}
\title{expand or collapse handler}
\usage{
  \method{addHandlerChanged}{GExpandGroup}(obj, handler,
    action, ...)

  \method{addHandlerChanged}{GTable}(obj, handler,
    action = NULL, ...)

  \method{addHandlerSelect}{GTable}(obj, handler,
    action = NULL, ...)

  \method{addHandlerClicked}{GTable}(obj, handler,
    action = NULL, ...)

  \method{addHandlerDoubleclick}{GTable}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChanged}{default}(obj, handler,
    action = NULL, ...)

  \method{addHandlerClicked}{default}(obj, handler,
    action = NULL, ...)

  \method{addHandlerDoubleclick}{default}(obj, handler,
    action = NULL, ...)

  \method{addHandlerEnter}{default}(obj, handler,
    action = NULL, ...)

  \method{addHandlerBlur}{default}(obj, handler,
    action = NULL, ...)

  \method{addHandlerSelect}{default}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChange}{default}(obj, handler,
    action = NULL, ...)

  \method{addHandlerMouseDown}{default}(obj, handler,
    action = NULL, ...)

  \method{addHandlerMouseUp}{default}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChanged}{GEdit}(obj, handler,
    action = NULL, ...)

  \method{addHandlerBlur}{GEdit}(obj, handler,
    action = NULL, ...)

  \method{addHandlerEnter}{GEdit}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChanged}{GCombobox}(obj, handler,
    action = NULL, ...)

  \method{addHandlerBlur}{GCombobox}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChange}{GCombobox}(obj, handler,
    action = NULL, ...)

  \method{addHandlerSelect}{GCombobox}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChanged}{GNotebook}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChanged}{GRadio}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChange}{GRadio}(obj, handler,
    action = NULL, ...)

  \method{addHandlerClicked}{GRadio}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChange}{GCheckboxGroup}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChanged}{GSequenceSelect}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChange}{GSequenceSelect}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChange}{GSlider}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChanged}{GAction}(obj, handler,
    action = NULL, ...)

  \method{addHandlerBlur}{GText}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChanged}{GTable}(obj, handler,
    action = NULL, ...)

  \method{addHandlerClicked}{GCanvas}(obj, handler,
    action = NULL, ...)

  \method{addHandlerMouseDown}{GCanvas}(obj, handler,
    action = NULL, ...)

  \method{addHandlerMouseUp}{GCanvas}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChanged}{GPanel}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChanged}{GCalendar}(obj, handler,
    action = NULL, ...)

  \method{addHandlerChanged}{GFile}(obj, handler,
    action = NULL, ...)
}
\arguments{
  \item{obj}{object that emits signal}

  \item{handler}{handler. A function with first argument
  which receives a list.}

  \item{action}{object to pass to function call to
  parameterize it}

  \item{...}{passed along}
}
\description{
  expand or collapse handler

  changed event

  changed event

  changed event

  changed event

  Default S3 method

  Default S3 method

  Default S3 method

  Default S3 method

  Default S3 method

  Default S3 method

  Default S3 method

  Default S3 method

  Default S3 method

  gedit changed event

  gedit blur event

  gedit changed event

  comobox change value method

  comobox blue event

  comobox change event

  comobox select event

  chagne is tabchange

  gradio changed event

  gradio changed event

  gradio changed event

  Change event for checkbox group

  changed event

  changed event

  gradio changed event

  use action as signal

  blur event

  changed event

  Click handler for canvas widget

  Default S3 method

  Default S3 method

  gpanel onload event

  Default S3 method

  gedit changed event
}

