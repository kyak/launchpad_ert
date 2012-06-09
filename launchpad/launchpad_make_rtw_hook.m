function launchpad_make_rtw_hook(hookMethod,modelName,~,~,~,~)
switch hookMethod
    case 'before_make'
        launchpadBeforeMakeHook(modelName);
    case 'after_make'
        launchpadAfterMakeHook(modelName);
end