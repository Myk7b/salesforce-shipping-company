import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const showToast = (variant, title, message) => {
    const event = new ShowToastEvent ({
        variant: variant,
        title: title,
        message: message
    });
    return event;
}

export { showToast };