function [optionValue] = getOption(options, fieldName, defaultValue)
%Zwraca warto�� opcji. Je�li jest ona dost�pna w strukturze 'options'
%w polu 'fieldName' to jest to warto�� z tej struktury. 
%Je�li nie zwracana jest warto�� domy�lna: 'defaultValue'.

if isfield(options, fieldName)
    optionValue = getfield(options, fieldName);
else
    optionValue = defaultValue;
end;
